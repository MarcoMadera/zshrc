# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   UI Tweaks & Visual Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ Load Color Definitions ━━━━━━━━━
autoload -Uz colors && colors

# ━━━━━━━ SSH Visual Prompt Tag ━━━━━━━━━
if [[ -n "$SSH_CONNECTION" ]]; then
  PROMPT="%F{red}[SSH]%f $PROMPT"
fi

# ━━━━━━━ OS-specific Aliases ━━━━━━━━━
case "$(uname)" in
  Darwin) alias ls='ls -G' ;;
  Linux)  alias ls='ls --color=auto' ;;
esac

# ━━━━━━━ Dynamic Terminal Palette Reapply ━━━━━━━━━
seqfile="${XDG_CACHE_HOME:-$HOME/.cache}/ags/user/generated/terminal/sequences.txt"

# Define cat override globally
if [[ -o interactive ]]; then
  function cat() {
    if [[ "$1" == "$seqfile" ]]; then
      command cat "$@"
    else
      bat --paging=never "$@"
    fi
  }
fi

# Palette hook only for Linux
if [[ "$(uname)" == "Linux" && -o interactive ]]; then
  autoload -Uz add-zsh-hook
  apply_palette() {
    if [[ -r $seqfile ]]; then
      IFS= read -r palette <"$seqfile"
      printf '%b' "$palette"
    fi
  }

  add-zsh-hook precmd apply_palette
fi
