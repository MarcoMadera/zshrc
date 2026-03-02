# Enable prompt variable expansion
setopt prompt_subst
autoload -Uz add-zsh-hook
zmodload zsh/stat

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
  "enable_git_pill"       "true"
  "enable_git_state_pill"   "true"
  "enable_git_metrics_pill" "true"
  "enable_python_pill"      "true"
  "enable_node_pill"    "true"
  "enable_java_pill"    "true"
  "enable_go_pill"      "true"
  "enable_rust_pill"    "true"
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
PALETTES[mocha.go_bg]="74c7ec"           # Sapphire
PALETTES[mocha.go_fg]="1e1e2e"           # Base
PALETTES[mocha.rust_bg]="fab387"         # Peach
PALETTES[mocha.rust_fg]="1e1e2e"         # Base
PALETTES[mocha.git_state_bg]="f9e2af"      # Yellow
PALETTES[mocha.git_state_fg]="1e1e2e"      # Base
PALETTES[mocha.git_metrics_bg]="313244"    # Surface0
PALETTES[mocha.git_metrics_fg]="cdd6f4"    # Text
PALETTES[mocha.duration_bg]="45475a"       # Surface1
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
PALETTES[frappe.go_bg]="85c1dc"           # Sapphire
PALETTES[frappe.go_fg]="303446"           # Base
PALETTES[frappe.rust_bg]="ef9f76"         # Peach
PALETTES[frappe.rust_fg]="303446"         # Base
PALETTES[frappe.git_state_bg]="e5c890"      # Yellow
PALETTES[frappe.git_state_fg]="303446"      # Base
PALETTES[frappe.git_metrics_bg]="414559"    # Surface0
PALETTES[frappe.git_metrics_fg]="c6d0f5"    # Text
PALETTES[frappe.duration_bg]="51576d"       # Surface1
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
PALETTES[latte.go_bg]="209fb5"           # Sapphire
PALETTES[latte.go_fg]="eff1f5"           # Base
PALETTES[latte.rust_bg]="fe640b"         # Peach
PALETTES[latte.rust_fg]="eff1f5"         # Base
PALETTES[latte.git_state_bg]="df8e1d"      # Yellow
PALETTES[latte.git_state_fg]="eff1f5"      # Base
PALETTES[latte.git_metrics_bg]="ccd0da"    # Surface0
PALETTES[latte.git_metrics_fg]="4c4f69"    # Text
PALETTES[latte.duration_bg]="e6e9ef"       # Surface1
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

# Check if the current directory contains any file with the given extension
function _has_ext() {
  local -a m=($PWD/*.$1(N[1]))
  (( ${#m} ))
}

typeset -g _node_cache_ver="" _java_cache_ver="" _python_cache_ver="" _go_cache_ver="" _rust_cache_ver=""
typeset -g _cmd_start=""
typeset -g _last_node_path="" _last_java_path="" _last_python_path="" _last_go_path="" _last_rust_path=""
typeset -g _current_git_dir=""
typeset -g _git_metrics_cache="" _git_metrics_index_mtime="" _git_metrics_head=""
typeset -g _git_is_dirty=""

function _preexec_timer() { _cmd_start=$EPOCHSECONDS }
add-zsh-hook preexec _preexec_timer

function _refresh_env_cache() {
  # ── Node ──
  if _find_up "package.json" || _find_up ".nvmrc"; then
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

  # ── Python ──
  if _find_up ".python-version" || _find_up "Pipfile" || _find_up "pyproject.toml" || \
     _find_up "requirements.txt" || _find_up "setup.py" || _find_up "tox.ini" || \
     [[ -n "$VIRTUAL_ENV" ]] || [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]] || \
     _has_ext py || _has_ext ipynb; then
    # Include active env in fingerprint so switching envs triggers a re-check
    local current_python="${VIRTUAL_ENV:-}:${CONDA_DEFAULT_ENV:-}:$(whence -p python3 2>/dev/null || whence -p python 2>/dev/null)"
    if [[ "$current_python" != "$_last_python_path" ]]; then
      _last_python_path="$current_python"
      if command -v pyenv &>/dev/null; then
        _python_cache_ver="$(pyenv version-name 2>/dev/null)"
      else
        _python_cache_ver="$(python3 --version 2>/dev/null || python --version 2>/dev/null)"
        _python_cache_ver="${_python_cache_ver#Python }"
      fi
    fi
  else
    _python_cache_ver=""
    _last_python_path=""
  fi

  # ── Go ──
  if _find_up "go.mod" || _find_up "go.sum" || _find_up "go.work" || \
     _find_up "glide.yaml" || _find_up "Gopkg.yml" || _find_up "Gopkg.lock" || \
     _find_up ".go-version" || [[ -d "$PWD/Godeps" ]] || _has_ext go; then
    local current_go
    current_go="$(whence -p go 2>/dev/null)"
    if [[ "$current_go" != "$_last_go_path" ]]; then
      _last_go_path="$current_go"
      local ver
      ver="$(go env GOVERSION 2>/dev/null)"
      _go_cache_ver="${ver#go}"
    fi
  else
    _go_cache_ver=""
    _last_go_path=""
  fi

  # ── Rust ──
  if _find_up "Cargo.toml" || _find_up "Cargo.lock" || _has_ext rs; then
    local current_rust
    current_rust="$(whence -p rustc 2>/dev/null)"
    if [[ "$current_rust" != "$_last_rust_path" ]]; then
      _last_rust_path="$current_rust"
      local ver
      ver="$(rustc --version 2>/dev/null)"
      ver="${ver#rustc }"
      _rust_cache_ver="${ver%% *}"
    fi
  else
    _rust_cache_ver=""
    _last_rust_path=""
  fi
}

add-zsh-hook precmd _refresh_env_cache
add-zsh-hook chpwd _refresh_env_cache

function _refresh_git_metrics() {
  _current_git_dir="$(command git rev-parse --absolute-git-dir 2>/dev/null)"

  if [[ -z "$_current_git_dir" ]]; then
    _git_metrics_cache=""
    _git_is_dirty=""
    _git_metrics_index_mtime=""
    _git_metrics_head=""
    return
  fi

  local -A _st
  zstat -H _st +mtime "$_current_git_dir/index" 2>/dev/null
  local cur_mtime="${_st[mtime]:-}"
  local cur_head=""
  [[ -f "$_current_git_dir/HEAD" ]] && cur_head="$(<"$_current_git_dir/HEAD")"

  if [[ "$cur_mtime" == "$_git_metrics_index_mtime" && "$cur_head" == "$_git_metrics_head" ]]; then
    return
  fi

  _git_metrics_index_mtime="$cur_mtime"
  _git_metrics_head="$cur_head"

  local porcelain
  porcelain="$(command git status --porcelain 2>/dev/null)"
  _git_is_dirty="${porcelain:+1}"

  if [[ "${PROMPT_CONFIG[enable_git_metrics_pill]}" == "true" ]]; then
    local shortstat added=0 deleted=0
    shortstat="$(command git diff --shortstat --no-ext-diff --ignore-submodules HEAD 2>/dev/null)"
    [[ "$shortstat" =~ '([0-9]+) insertion' ]] && added="${match[1]}"
    [[ "$shortstat" =~ '([0-9]+) deletion'  ]] && deleted="${match[1]}"
    if (( added == 0 && deleted == 0 )); then
      _git_metrics_cache=""
    else
      _git_metrics_cache="${added}:${deleted}"
    fi
  fi
}


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

  local bg fg

  if [[ "$_git_is_dirty" == "1" ]]; then
    bg="$(palette git_dirty_bg)"
    fg="$(palette git_dirty_fg)"
  else
    bg="$(palette git_clean_bg)"
    fg="$(palette git_clean_fg)"
  fi

  create_pill "${vcs_info_msg_0_}" "$bg" "$fg"
}

function build_git_state_pill() {
  [[ "${PROMPT_CONFIG[enable_git_state_pill]}" != "true" ]] && return
  [[ -z "$vcs_info_msg_0_" ]] && return
  [[ -z "$_current_git_dir" ]] && return

  local git_dir="$_current_git_dir"

  local state="" progress=""

  if [[ -d "$git_dir/rebase-merge" ]]; then
    state="REBASING"
    local cur="" tot=""
    [[ -f "$git_dir/rebase-merge/msgnum" ]] && cur="$(<"$git_dir/rebase-merge/msgnum")"
    [[ -f "$git_dir/rebase-merge/end"    ]] && tot="$(<"$git_dir/rebase-merge/end")"
    cur="${cur//[[:space:]]/}"; tot="${tot//[[:space:]]/}"
    [[ -n "$cur" && -n "$tot" ]] && progress="$cur/$tot"
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    if   [[ -f "$git_dir/rebase-apply/rebasing" ]]; then state="REBASING"
    elif [[ -f "$git_dir/rebase-apply/applying" ]]; then state="AM"
    else                                                  state="AM/REBASE"
    fi
    local cur="" tot=""
    [[ -f "$git_dir/rebase-apply/next" ]] && cur="$(<"$git_dir/rebase-apply/next")"
    [[ -f "$git_dir/rebase-apply/last" ]] && tot="$(<"$git_dir/rebase-apply/last")"
    cur="${cur//[[:space:]]/}"; tot="${tot//[[:space:]]/}"
    [[ -n "$cur" && -n "$tot" ]] && progress="$cur/$tot"
  elif [[ -f "$git_dir/MERGE_HEAD"       ]]; then state="MERGING"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then state="CHERRY-PICKING"
  elif [[ -f "$git_dir/REVERT_HEAD"      ]]; then state="REVERTING"
  elif [[ -f "$git_dir/BISECT_LOG"       ]]; then state="BISECTING"
  fi

  [[ -z "$state" ]] && return

  local content="$state"
  [[ -n "$progress" ]] && content+=" $progress"

  create_pill "$content" "$(palette git_state_bg)" "$(palette git_state_fg)"
}

function build_git_metrics_pill() {
  [[ "${PROMPT_CONFIG[enable_git_metrics_pill]}" != "true" ]] && return
  [[ -z "$_git_metrics_cache" ]] && return

  local added="${_git_metrics_cache%%:*}"
  local deleted="${_git_metrics_cache##*:}"

  local bg="$(palette git_metrics_bg)"
  local fg="$(palette git_metrics_fg)"
  local green="$(palette git_clean_bg)"
  local red="$(palette git_dirty_bg)"

  local content="%F{#$green}+${added}%F{#$fg} %F{#$red}-${deleted}%F{#$fg}"
  create_pill "$content" "$bg" "$fg"
}

function build_python_pill() {
  [[ "${PROMPT_CONFIG[enable_python_pill]}" != "true" ]] && return

  [[ -z "$_python_cache_ver" ]] && return

  local icon="%F{#FFD43B}%F{#D0E8F7}"
  local content="${icon} $_python_cache_ver"
  local env_name=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    env_name="${VIRTUAL_ENV:t}"
  elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
    env_name="$CONDA_DEFAULT_ENV"
  fi
  [[ -n "$env_name" ]] && content+=" ($env_name)"

  create_pill "$content" "1E3D5C" "D0E8F7"
}

function build_node_pill() {
  [[  "${PROMPT_CONFIG[enable_node_pill]}" != "true" ]] && return
  [[ -z "$_node_cache_ver" ]] && return
  local node_icon="%F{#6CC24A}%F{#C8E8C8}"
  create_pill "${node_icon} $_node_cache_ver" "1A3D1A" "C8E8C8"
}

function build_java_pill() {
  [[ "${PROMPT_CONFIG[enable_java_pill]}" != "true" ]] && return
  [[ -z "$_java_cache_ver" ]] && return
  local java_icon="%F{#ED8B00}%F{#D0E8F7}"
  create_pill "${java_icon} $_java_cache_ver" "1E3A5F" "D0E8F7"
}

function build_go_pill() {
  [[ "${PROMPT_CONFIG[enable_go_pill]}" != "true" ]] && return
  [[ -z "$_go_cache_ver" ]] && return

  local icon="%F{#8FD2F9}%F{#D0E8F7}"
  local content="${icon} $_go_cache_ver"
  local bg="30677E"
  local fg="D0E8F7"

  create_pill "$content" "$bg" "$fg"
}

function build_rust_pill() {
  [[ "${PROMPT_CONFIG[enable_rust_pill]}" != "true" ]] && return
  [[ -z "$_rust_cache_ver" ]] && return
  local rust_icon="%F{#CE422B}%F{#F0C5BF}"
  create_pill "${rust_icon} $_rust_cache_ver" "2B1412" "F0C5BF"
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

  # Run in main shell so globals (_current_git_dir, _git_metrics_cache, _git_is_dirty) are set
  # before the pill builders read them. A separate precmd hook breaks the hook chain.
  _refresh_git_metrics

  local time_pill=$(build_time_pill)
  local mode_pill=$(build_mode_pill)
  local dir_pill=$(build_dir_pill)
  local git_pill=$(build_git_pill)
  local git_state_pill=$(build_git_state_pill)
  local git_metrics_pill=$(build_git_metrics_pill)
  local python_pill=$(build_python_pill)
  local node_pill=$(build_node_pill)
  local java_pill=$(build_java_pill)
  local go_pill=$(build_go_pill)
  local rust_pill=$(build_rust_pill)
  local duration_pill=$(build_duration_pill "$_elapsed")
  local prompt_char=$(build_prompt_char)

  [[ -n "$time_pill" ]]     && pills+=("$time_pill")
  [[ -n "$mode_pill" ]]     && pills+=("$mode_pill")
  [[ -n "$dir_pill" ]]      && pills+=("$dir_pill")
  [[ -n "$git_pill" ]]       && pills+=("$git_pill")
  [[ -n "$git_state_pill" ]]    && pills+=("$git_state_pill")
  [[ -n "$git_metrics_pill" ]]  && pills+=("$git_metrics_pill")
  [[ -n "$python_pill" ]]       && pills+=("$python_pill")
  [[ -n "$node_pill" ]]     && pills+=("$node_pill")
  [[ -n "$java_pill" ]]     && pills+=("$java_pill")
  [[ -n "$go_pill" ]]       && pills+=("$go_pill")
  [[ -n "$rust_pill" ]]     && pills+=("$rust_pill")
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
