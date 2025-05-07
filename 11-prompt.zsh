# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Prompt Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

setopt prompt_subst
autoload -Uz add-zsh-hook

_parse_rgb() {
  local raw=${1#*rgb:}; local IFS='/'; local R16 G16 B16
  read -r R16 G16 B16 <<<"$raw"
  printf '%d %d %d' $((0x$R16>>8)) $((0x$G16>>8)) $((0x$B16>>8))
}

_soft_boost_rgb() {
  local r=$1 g=$2 b=$3; local max=$(( r>g ? (r>b?r:b) : (g>b?g:b) ))
  printf '%d %d %d' \
    $(( r + (255-r)* (r==max?10:5) /100 )) \
    $(( g + (255-g)* (g==max?10:5) /100 )) \
    $(( b + (255-b)* (b==max?10:5) /100 ))
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
autoload -Uz vcs_info
add-zsh-hook precmd  vcs_info
add-zsh-hook chpwd   vcs_info

_prompt_rgb_cache=""
cache_prompt_rgb() {
  [[ -n "$_prompt_rgb_cache" ]] && return

  local file="${PROMPT_RGB_FILE:-$XDG_CACHE_HOME/ags/user/generated/terminal/background_rgb.txt}"
  if [[ -f "$file" ]]; then
  read -r r g b < "$file"
  read -r r g b <<< "$(_soft_boost_rgb $r $g $b)"
  _prompt_rgb_cache="$r $g $b"
  else
    _prompt_rgb_cache=""  # <-- no color
  fi
  read -r r g b <<< "$(_soft_boost_rgb $r $g $b)"
  _prompt_rgb_cache="$r $g $b"
}

build_prompt() {
  cache_prompt_rgb

  if [[ -z "$_prompt_rgb_cache" ]]; then
    # keep it simple in mac
    PROMPT=$' $(date +%H:%M) %{${MODE:-}%} %~ ❯ '
    return
  fi

  local r g b; read -r r g b <<< "$_prompt_rgb_cache"

  printf -v BG_ESC '\e[48;2;%d;%d;%dm' $r $g $b
  if (( (r+g+b)/3 < 128 )); then FG_ESC=$'\e[38;2;255;255;255m'
  else                           FG_ESC=$'\e[38;2;0;0;0m'
  fi
  RESET_ESC=$'\e[0m' ; YEL_ESC=$'\e[38;5;11m'

  BG="%{${BG_ESC}%}" FG="%{${FG_ESC}%}" RESET="%{${RESET_ESC}%}"
  YELLOW="%{${YEL_ESC}%}"

  local git=""
  [[ $vcs_info_msg_0_ ]] && git=" ${YELLOW} ${vcs_info_msg_0_}${FG}"

  PROMPT=${BG}${FG}$' $(date +%H:%M) %{${MODE:-}%} %~'${git}$' ❯'${RESET}
}

add-zsh-hook precmd build_prompt
