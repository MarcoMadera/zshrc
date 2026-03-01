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
  "enable_python_pill"  "true"
  "enable_node_pill"    "true"
  "enable_java_pill"    "true"
  "enable_duration_pill" "true"
  "duration_threshold"  "3"
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
PALETTES[mocha.python_bg]="89dceb"       # Sky
PALETTES[mocha.python_fg]="1e1e2e"       # Base
PALETTES[mocha.node_bg]="f2cdcd"         # Flamingo
PALETTES[mocha.node_fg]="1e1e2e"         # Base
PALETTES[mocha.java_bg]="eba0ac"         # Maroon
PALETTES[mocha.java_fg]="1e1e2e"         # Base
PALETTES[mocha.duration_bg]="45475a"     # Surface1
PALETTES[mocha.duration_fg]="cdd6f4"     # Text

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
PALETTES[frappe.python_bg]="99d1db"       # Sky
PALETTES[frappe.python_fg]="303446"       # Base
PALETTES[frappe.node_bg]="f2d5cf"         # Rosewater
PALETTES[frappe.node_fg]="303446"         # Base
PALETTES[frappe.java_bg]="ea999c"         # Maroon
PALETTES[frappe.java_fg]="303446"         # Base
PALETTES[frappe.duration_bg]="51576d"     # Surface1
PALETTES[frappe.duration_fg]="c6d0f5"     # Text

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
PALETTES[latte.python_bg]="04a5e5"       # Sky
PALETTES[latte.python_fg]="eff1f5"       # Base
PALETTES[latte.node_bg]="dc8a78"         # Rosewater
PALETTES[latte.node_fg]="eff1f5"         # Base
PALETTES[latte.java_bg]="e64553"         # Maroon
PALETTES[latte.java_fg]="eff1f5"         # Base
PALETTES[latte.duration_bg]="e6e9ef"     # Surface1
PALETTES[latte.duration_fg]="5c5f77"     # Subtext0

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

# ──────────── Utilities ────────────

function _find_up() {
  local file="$1" dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    [[ -f "$dir/$file" ]] && return 0
    dir="${dir:h}"
  done
  return 1
}

typeset -g _node_cache_ver="" _java_cache_ver=""
typeset -g _cmd_start=""
typeset -g _last_node_path="" _last_java_path=""

function _preexec_timer() { _cmd_start=$EPOCHSECONDS }
add-zsh-hook preexec _preexec_timer

function _refresh_env_cache() {
  # ── Node ──
  if _find_up "package.json" || _find_up ".nvmrc"; then
    # nvm switches change the binary path in PATH — whence -p detects that
    local current_node
    current_node="$(whence -p node 2>/dev/null)"
    if [[ "$current_node" != "$_last_node_path" ]]; then
      _last_node_path="$current_node"
      _node_cache_ver="$(node --version 2>/dev/null)"
      _node_cache_ver="${_node_cache_ver#v}"
    fi
  else
    _node_cache_ver=""
    _last_node_path=""
  fi

  # ── Java ──
  if _find_up "pom.xml" || _find_up "build.gradle" || _find_up "build.gradle.kts"; then
    # On Linux, update-alternatives changes the symlink chain under /usr/bin/java.
    # readlink -f resolves it fully; falls back to whence -p on macOS.
    local current_java
    current_java="$(readlink -f "$(whence -p java 2>/dev/null)" 2>/dev/null)"
    [[ -z "$current_java" ]] && current_java="$(whence -p java 2>/dev/null)"
    if [[ "$current_java" != "$_last_java_path" ]]; then
      _last_java_path="$current_java"
      local raw ver
      raw="$(java -version 2>&1 | head -1)"
      ver="${raw#*version \"}"
      ver="${ver%%\"*}"
      [[ "$ver" == 1.* ]] && ver="${ver#1.}" && ver="${ver%%.*}" || ver="${ver%%.*}"
      _java_cache_ver="$ver"
    fi
  else
    _java_cache_ver=""
    _last_java_path=""
  fi
}

add-zsh-hook precmd _refresh_env_cache
add-zsh-hook chpwd _refresh_env_cache

# ──────────── Pill Builders ────────────

function build_time_pill() {
  [[ "${PROMPT_CONFIG[enable_time_pill]}" != "true" ]] && return
  
  local clock_icon="${PROMPT_CONFIG[clock_icon]}"
  local current_time="%B$(strftime '%H:%M' $EPOCHSECONDS)%b"

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

  if [[ -n "$(command git status --porcelain 2>/dev/null)" ]]; then
    bg="$(palette git_dirty_bg)"
    fg="$(palette git_dirty_fg)"
  else
    bg="$(palette git_clean_bg)"
    fg="$(palette git_clean_fg)"
  fi

  create_pill "${vcs_info_msg_0_}" "$bg" "$fg"
}

function build_python_pill() {
  [[ "${PROMPT_CONFIG[enable_python_pill]}" != "true" ]] && return

  local env_name
  if [[ -n "$VIRTUAL_ENV" ]]; then
    env_name="${VIRTUAL_ENV:t}"
  elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
    env_name="$CONDA_DEFAULT_ENV"
  else
    return
  fi

  create_pill " $env_name" "$(palette python_bg)" "$(palette python_fg)"
}

function build_node_pill() {
  [[  "${PROMPT_CONFIG[enable_node_pill]}" != "true" ]] && return
  [[ -z "$_node_cache_ver" ]] && return
  create_pill "⬢ $_node_cache_ver" "$(palette node_bg)" "$(palette node_fg)"
}

function build_java_pill() {
  [[ "${PROMPT_CONFIG[enable_java_pill]}" != "true" ]] && return
  [[ -z "$_java_cache_ver" ]] && return
  create_pill " $_java_cache_ver" "$(palette java_bg)" "$(palette java_fg)"
}

function build_duration_pill() {
  [[ "${PROMPT_CONFIG[enable_duration_pill]}" != "true" ]] && return
  local elapsed="$1"
  [[ -z "$elapsed" ]] && return

  (( elapsed < ${PROMPT_CONFIG[duration_threshold]:-3} )) && return

  local label
  if (( elapsed >= 3600 )); then
    label="$(( elapsed / 3600 ))h $(( (elapsed % 3600) / 60 ))m"
  elif (( elapsed >= 60 )); then
    label="$(( elapsed / 60 ))m $(( elapsed % 60 ))s"
  else
    label="${elapsed}s"
  fi

  create_pill "󰔛 $label" "$(palette duration_bg)" "$(palette duration_fg)"
}

function build_prompt_char() {
  local fg="$(palette primary_fg)"
  echo "%F{#$fg}${PROMPT_CONFIG[prompt_char]}  %f"
}

function build_prompt() {
  local separator="${PROMPT_CONFIG[pill_separator]}"
  local pills=()

  # Compute elapsed and clear timer in parent scope — subshells can't do this
  local _elapsed=""
  if [[ -n "$_cmd_start" ]]; then
    _elapsed=$(( EPOCHSECONDS - _cmd_start ))
    _cmd_start=""
  fi

  local time_pill=$(build_time_pill)
  local mode_pill=$(build_mode_pill)
  local dir_pill=$(build_dir_pill)
  local git_pill=$(build_git_pill)
  local python_pill=$(build_python_pill)
  local node_pill=$(build_node_pill)
  local java_pill=$(build_java_pill)
  local duration_pill=$(build_duration_pill "$_elapsed")
  local prompt_char=$(build_prompt_char)

  [[ -n "$time_pill" ]]     && pills+=("$time_pill")
  [[ -n "$mode_pill" ]]     && pills+=("$mode_pill")
  [[ -n "$dir_pill" ]]      && pills+=("$dir_pill")
  [[ -n "$git_pill" ]]      && pills+=("$git_pill")
  [[ -n "$python_pill" ]]   && pills+=("$python_pill")
  [[ -n "$node_pill" ]]     && pills+=("$node_pill")
  [[ -n "$java_pill" ]]     && pills+=("$java_pill")
  [[ -n "$duration_pill" ]] && pills+=("$duration_pill")
  
  local top_line=""
  for pill in "${pills[@]}"; do
    [[ -n "$top_line" ]] && top_line+="$separator"
    top_line+="$pill"
  done

  PROMPT="${top_line}"$'\n'"${prompt_char}"
  [[ -n "$SSH_CONNECTION" ]] && PROMPT="%F{red}[SSH]%f $PROMPT"
}

add-zsh-hook precmd build_prompt
