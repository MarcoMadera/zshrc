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
  "primary_color"       "FF8906"
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

# ──────────── Palette Engine ────────────

CURRENT_PALETTE="mocha"   # ← change only this  (mocha | frappe | latte)

typeset -A PALETTES

# ── Catppuccin Mocha (dark) ──
PALETTES[mocha.primary_fg]="fab387"   # Peach
PALETTES[mocha.time_bg]="313244"      # Surface0
PALETTES[mocha.time_fg]="cdd6f4"      # Text
PALETTES[mocha.dir_bg]="94e2d5"       # Teal
PALETTES[mocha.dir_fg]="1e1e2e"       # Base
PALETTES[mocha.git_clean_bg]="a6e3a1" # Green
PALETTES[mocha.git_clean_fg]="1e1e2e" # Base
PALETTES[mocha.git_dirty_bg]="f38ba8" # Red
PALETTES[mocha.git_dirty_fg]="1e1e2e" # Base
PALETTES[mocha.mode_insert_bg]="89b4fa"  # Blue
PALETTES[mocha.mode_insert_fg]="1e1e2e"  # Base
PALETTES[mocha.mode_normal_bg]="f9e2af"  # Yellow
PALETTES[mocha.mode_normal_fg]="1e1e2e"  # Base
PALETTES[mocha.mode_visual_bg]="cba6f7"  # Mauve
PALETTES[mocha.mode_visual_fg]="1e1e2e"  # Base
PALETTES[mocha.mode_visbk_bg]="f5c2e7"   # Pink
PALETTES[mocha.mode_visbk_fg]="1e1e2e"   # Base

# ── Catppuccin Frappé (medium) ──
PALETTES[frappe.primary_fg]="ef9f76"   # Peach
PALETTES[frappe.time_bg]="414559"      # Surface0
PALETTES[frappe.time_fg]="c6d0f5"      # Text
PALETTES[frappe.dir_bg]="81c8be"       # Teal
PALETTES[frappe.dir_fg]="303446"       # Base
PALETTES[frappe.git_clean_bg]="a6d189" # Green
PALETTES[frappe.git_clean_fg]="303446" # Base
PALETTES[frappe.git_dirty_bg]="e78284" # Red
PALETTES[frappe.git_dirty_fg]="303446" # Base
PALETTES[frappe.mode_insert_bg]="8caaee"  # Blue
PALETTES[frappe.mode_insert_fg]="303446"  # Base
PALETTES[frappe.mode_normal_bg]="e5c890"  # Yellow
PALETTES[frappe.mode_normal_fg]="303446"  # Base
PALETTES[frappe.mode_visual_bg]="ca9ee6"  # Mauve
PALETTES[frappe.mode_visual_fg]="303446"  # Base
PALETTES[frappe.mode_visbk_bg]="f4b8e4"   # Pink
PALETTES[frappe.mode_visbk_fg]="303446"   # Base

# ── Catppuccin Latte (light) ──
PALETTES[latte.primary_fg]="fe640b"   # Peach
PALETTES[latte.time_bg]="ccd0da"      # Surface0
PALETTES[latte.time_fg]="4c4f69"      # Text
PALETTES[latte.dir_bg]="179299"       # Teal
PALETTES[latte.dir_fg]="eff1f5"       # Base
PALETTES[latte.git_clean_bg]="40a02b" # Green
PALETTES[latte.git_clean_fg]="eff1f5" # Base
PALETTES[latte.git_dirty_bg]="d20f39" # Red
PALETTES[latte.git_dirty_fg]="eff1f5" # Base
PALETTES[latte.mode_insert_bg]="1e66f5"  # Blue
PALETTES[latte.mode_insert_fg]="eff1f5"  # Base
PALETTES[latte.mode_normal_bg]="df8e1d"  # Yellow
PALETTES[latte.mode_normal_fg]="eff1f5"  # Base
PALETTES[latte.mode_visual_bg]="8839ef"  # Mauve
PALETTES[latte.mode_visual_fg]="eff1f5"  # Base
PALETTES[latte.mode_visbk_bg]="ea76cb"   # Pink
PALETTES[latte.mode_visbk_fg]="eff1f5"   # Base

function palette() {
  echo "${PALETTES[${CURRENT_PALETTE}.$1]}"
}

function create_pill() {
  local content="$1"
  local bg="$2"
  local fg="$3"

  local left="%F{#$bg}%f"
  local right="%F{#$bg}%f"

  echo "${left}%K{#$bg}%F{#$fg}${content}%f%k${right}"
}

function build_time_pill() {
  [[ "${PROMPT_CONFIG[enable_time_pill]}" != "true" ]] && return
  
  local clock_icon="${PROMPT_CONFIG[clock_icon]}"
  local current_time="%B$(date +%H:%M)%b"

  local bg="$(palette time_bg)"
  local fg="$(palette time_fg)"

  create_pill "${clock_icon} ${current_time}" "$bg" "$fg"
}

function build_mode_pill() {
  [[ "${PROMPT_CONFIG[enable_mode_pill]}" != "true" ]] && return
  
  echo "\${MODE:-}"
}

function build_dir_pill() {
  [[ "${PROMPT_CONFIG[enable_dir_pill]}" != "true" ]] && return

  local dir_path="${PWD/#$HOME/${PROMPT_CONFIG[home_icon]}}"

  local bg="$(palette dir_bg)"
  local fg="$(palette dir_fg)"

  create_pill "$dir_path" "$bg" "$fg"
}

function build_git_pill() {
  [[ "${PROMPT_CONFIG[enable_git_pill]}" != "true" ]] && return
  [[ -z "$vcs_info_msg_0_" ]] && return

  local bg
  local fg

  if [[ -n "$(gs --porcelain 2>/dev/null)" ]]; then
    bg="$(palette git_dirty_bg)"
    fg="$(palette git_dirty_fg)"
  else
    bg="$(palette git_clean_bg)"
    fg="$(palette git_clean_fg)"
  fi

  create_pill "${vcs_info_msg_0_}" "$bg" "$fg"
}

function build_prompt_char() {
  local fg="$(palette primary_fg)"
  echo "%F{#$fg}${PROMPT_CONFIG[prompt_char]}  %f"
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
