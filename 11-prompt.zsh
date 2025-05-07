# Enable prompt variable expansion
setopt prompt_subst
autoload -Uz add-zsh-hook

# ──────────── Git Info ────────────
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
autoload -Uz vcs_info
add-zsh-hook precmd  vcs_info
add-zsh-hook chpwd   vcs_info


typeset -A PROMPT_CONFIG
PROMPT_CONFIG=(
  "primary_color"       "green"
  "text_color"          "black"
  "prompt_char"         "•  "
  "pill_separator"      " • "
  "clock_icon"          "󰥔"
  "home_icon"           "  "
  "enable_time_pill"    "true"
  "enable_mode_pill"    "true"
  "enable_dir_pill"     "true"
  "enable_git_pill"     "true"
)

function create_pill() {
  local content="$1"
  local color="${2:-${PROMPT_CONFIG[primary_color]}}"
  local text_color="${3:-${PROMPT_CONFIG[text_color]}}"
  
  local left_round="%F{$color}%f"
  local right_round="%F{$color}%f"
  
  echo "${left_round}%K{$color}%F{$text_color}${content}%f%k${right_round}"
}

function build_time_pill() {
  [[ "${PROMPT_CONFIG[enable_time_pill]}" != "true" ]] && return
  
  local clock_icon="${PROMPT_CONFIG[clock_icon]}"
  local current_time="%B$(date +%H:%M)%b"
  
  create_pill "${clock_icon} ${current_time}"
}

function build_mode_pill() {
  [[ "${PROMPT_CONFIG[enable_mode_pill]}" != "true" ]] && return
  
  echo "\${MODE:-}"
}

function build_dir_pill() {
  [[ "${PROMPT_CONFIG[enable_dir_pill]}" != "true" ]] && return

  local dir_path="${PWD/#$HOME/${PROMPT_CONFIG[home_icon]}}"
  create_pill "$dir_path"
}

function build_git_pill() {
  [[ "${PROMPT_CONFIG[enable_git_pill]}" != "true" ]] && return
  [[ -z "$vcs_info_msg_0_" ]] && return
  
  create_pill "${vcs_info_msg_0_}"
}

function build_prompt_char() {
  echo "%F{${PROMPT_CONFIG[primary_color]}}${PROMPT_CONFIG[prompt_char]}  %f"
}

function build_prompt() {
  local separator="${PROMPT_CONFIG[pill_separator]}"
  local pills=()
  
  local time_pill=$(build_time_pill)
  local mode_pill=$(build_mode_pill)
  local dir_pill=$(build_dir_pill)
  local git_pill=$(build_git_pill)
  local prompt_char=$(build_prompt_char)
  
  [[ -n "$time_pill" ]] && pills+=("$time_pill")
  [[ -n "$mode_pill" ]] && pills+=("$mode_pill")
  [[ -n "$dir_pill" ]] && pills+=("$dir_pill")
  [[ -n "$git_pill" ]] && pills+=("$git_pill")
  
  local top_line=$(join_by "$separator" "${pills[@]}")
  
  PROMPT="${top_line}"$'\n'"${prompt_char}"
}

# join array elements with a delimiter
function join_by() {
  local delimiter="$1"
  shift
  local result=""
  local first=true
  
  for item in "$@"; do
    if [[ "$first" == true ]]; then
      result="$item"
      first=false
    else
      result="${result}${delimiter}${item}"
    fi
  done
  
  echo "$result"
}

add-zsh-hook precmd build_prompt
