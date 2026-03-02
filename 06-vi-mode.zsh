bindkey -v

function format_mode_indicator() {
  local mode_name="$1"
  local key
  local label
  case "$mode_name" in
    INSERT) key="mode_insert"; label="i" ;;
    NORMAL) key="mode_normal"; label="n" ;;
    VISUAL) key="mode_visual"; label="v" ;;
    VIS-BK) key="mode_visbk"; label="b" ;;
  esac
  create_pill "$label" "$(palette ${key}_bg)" "$(palette ${key}_fg)"
}

function _init_mode_indicator() {
  MODE=$(format_mode_indicator "INSERT")
  add-zsh-hook -d precmd _init_mode_indicator
}
add-zsh-hook precmd _init_mode_indicator

function _set_cursor() {
  case "$1" in
    beam)  printf '\e[6 q' ;;  # steady bar  — insert
    block) printf '\e[2 q' ;;  # steady block — normal/visual
  esac
}

typeset -g _prev_region_active=0

function _update_mode_vars() {
  local current_mode

  if [[ $KEYMAP == vicmd ]]; then
    if [[ $REGION_ACTIVE == 1 ]]; then
      current_mode="VISUAL"
    elif [[ $REGION_ACTIVE == 2 ]]; then
      current_mode="VIS-BK"
    else
      current_mode="NORMAL"
    fi
  elif [[ $KEYMAP == visual ]]; then
    [[ $REGION_ACTIVE == 2 ]] && current_mode="VIS-BK" || current_mode="VISUAL"
  else
    current_mode="INSERT"
  fi

  MODE=$(format_mode_indicator "$current_mode")
  [[ $current_mode == "INSERT" ]] && _set_cursor beam || _set_cursor block

  # Only call reset-prompt when REGION_ACTIVE changes (entering/exiting visual mode).
  # Calling it unconditionally here causes an infinite redraw loop.
  if [[ $REGION_ACTIVE != $_prev_region_active ]]; then
    _prev_region_active=$REGION_ACTIVE
    zle reset-prompt 2>/dev/null || true
  fi
}

# Called by zle-keymap-select (INSERT ↔ NORMAL transitions)
function update_mode_indicator() {
  _update_mode_vars
  zle reset-prompt 2>/dev/null || true
}

function _zle_line_init() { _set_cursor beam }
function _zle_line_finish() { _set_cursor beam }

typeset -A SURROUND_PAIRS=(
  '(' ')'  '[' ']'  '{' '}'  '<' '>'
  '"' '"'  "'" "'"  '`' '`' 
)

_sur_pair() {
  local open="$1" close="${SURROUND_PAIRS[$1]}"
  
  [[ -n $close ]] && echo "$open $close"
}

_sur_find() {
  local key=$1
  local -a pair
  pair=(${(s: :)$(_sur_pair "$key")}) || return 1   # unknown delimiter

  local open=${pair[1]} close=${pair[2]}
  local buf=$BUFFER
  local len=${#buf}
  local cur=$CURSOR
  local matching_L=-1 matching_R=-1

  if [[ $open == $close ]]; then
    local L=$cur
    while (( L >= 0 )); do
      [[ ${buf:$L:1} == "$open" ]] && { matching_L=$L; break }
      (( L-- ))
    done
    local R=$(( cur + 1 ))
    while (( R < len )); do
      [[ ${buf:$R:1} == "$close" ]] && { matching_R=$R; break }
      (( R++ ))
    done

  else
    local L=$cur
    while (( L >= 0 )); do
      if [[ ${buf:$L:1} == "$open" ]]; then
        matching_L=$L
        break
      fi
      (( L-- ))
    done

    if (( matching_L >= 0 )); then
      local nest=1
      local R=$(( matching_L + 1 ))
      while (( R < len )); do
        if [[ ${buf:$R:1} == "$open" ]]; then
          (( nest++ ))
        elif [[ ${buf:$R:1} == "$close" ]]; then
          (( nest-- ))
          (( nest == 0 )) && { matching_R=$R; break }
        fi
        (( R++ ))
      done
    fi
  fi

  if (( matching_L >= 0 && matching_R > matching_L )); then
    print -r -- "$open $close $matching_L $matching_R"
    return 0
  fi
  return 1
}

_sur_readkey() {
  local timeout=2 #seconds
  local key
  
  read -t $timeout -k 1 key
  
  if [[ -n "$key" ]]; then
    REPLY=$key
    return 0
  else
    return 1
  fi
}

surround_add_visual() {
  local left right
  
  if (( REGION_ACTIVE == 2 )); then
    left=0
    right=$(( ${#BUFFER} - 1 ))
  else
    left=$MARK
    right=$CURSOR
    
    if (( left > right )); then
      local tmp=$left
      left=$right
      right=$tmp
    fi
  fi
  
  _sur_readkey || return 1
  local key=$REPLY
  
  local -a pair
  pair=(${(s: :)$(_sur_pair "$key")}) || return 1
  
  local head=${BUFFER:0:$left}
  local body=${BUFFER:$left:$(( right - left + 1 ))}
  local tail=${BUFFER:$(( right + 1 ))}
  
  BUFFER="${head}${pair[1]}${body}${pair[2]}${tail}"
  CURSOR=$left
  
  zle vi-cmd-mode
  REGION_ACTIVE=0
}

surround_operation() {
  local action=$1
  
  _sur_readkey || return 1
  local target=$REPLY
  
  local -a info
  info=(${(s: :)$(_sur_find "$target")}) || { 
    return 1
  }
  
  local L=${info[3]} R=${info[4]}
  
  if [[ $action == "d" ]]; then
    BUFFER="${BUFFER:0:$L}${BUFFER:$(( L + 1 )):$(( R - L - 1 ))}${BUFFER:$(( R + 1 ))}"
    CURSOR=$L
  else
    _sur_readkey || return 1
    local new=$REPLY
    local -a pair
    pair=(${(s: :)$(_sur_pair "$new")}) || return 1
    
    local new_open="${pair[1]}" new_close="${pair[2]}"
    BUFFER="${BUFFER:0:$L}${new_open}${BUFFER:$(( L + 1 )):$(( R - L - 1 ))}${new_close}${BUFFER:$(( R + 1 ))}"
    CURSOR=$L
  fi
}

surround_add_normal() {
  _sur_readkey || return 1
  local key=$REPLY
  
  local -a pair
  pair=(${(s: :)$(_sur_pair "$key")}) || return 1
  
  BUFFER="${pair[1]}${BUFFER}${pair[2]}"
  CURSOR=$(( CURSOR + ${#pair[1]} ))
}

surround_text_object() {
  local which=$1      # i  or  a
  local delim=$2      # ", ', (, [, …

  local -a info
  info=(${(s: :)$(_sur_find "$delim")}) || return 1
  local L=${info[3]}  R=${info[4]} 

  if [[ $which == i ]]; then
    (( L++ ))
    (( R-- ))
  fi

  MARK=$L
  CURSOR=$R
  zle redisplay 
}

surround_delete() { surround_operation "d" }
surround_change() { surround_operation "c" }

surround_vi_dquote() { surround_text_object "i" '"' }
surround_va_dquote() { surround_text_object "a" '"' }
surround_vi_squote() { surround_text_object "i" "'" }
surround_va_squote() { surround_text_object "a" "'" }
surround_vi_btick() { surround_text_object "i" "`" }
surround_va_btick() { surround_text_object "a" "`" }
surround_vi_paren() { surround_text_object "i" "(" }
surround_va_paren() { surround_text_object "a" "(" }
surround_vi_bracket() { surround_text_object "i" "[" }
surround_va_bracket() { surround_text_object "a" "[" }
surround_vi_brace() { surround_text_object "i" "{" }
surround_va_brace() { surround_text_object "a" "{" }
surround_vi_angle() { surround_text_object "i" "<" }
surround_va_angle() { surround_text_object "a" "<" }

zle -N surround_add_visual
zle -N surround_delete
zle -N surround_change
zle -N surround_add_normal

zle -N surround_vi_dquote
zle -N surround_va_dquote
zle -N surround_vi_squote
zle -N surround_va_squote
zle -N surround_vi_btick
zle -N surround_va_btick
zle -N surround_vi_paren
zle -N surround_va_paren
zle -N surround_vi_bracket
zle -N surround_va_bracket
zle -N surround_vi_brace
zle -N surround_va_brace
zle -N surround_vi_angle
zle -N surround_va_angle

zle -N zle-line-pre-redraw _update_mode_vars
zle -N zle-keymap-select update_mode_indicator
zle -N zle-line-init _zle_line_init
zle -N zle-line-finish _zle_line_finish
