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
# Palette hook only for Linux
if [[ "$(uname)" == "Linux" && -o interactive ]]; then
  autoload -Uz add-zsh-hook
  apply_palette() {
    if [[ -r $SEQFILE ]]; then
      IFS= read -r palette <"$SEQFILE"
      printf '%b' "$palette"
    fi
  }

  add-zsh-hook precmd apply_palette
fi
