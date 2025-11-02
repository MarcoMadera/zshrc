# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   UI Tweaks & Visual Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ Load Color Definitions ━━━━━━━━━
autoload -Uz colors && colors

# ━━━━━━━ SSH Visual Prompt Tag ━━━━━━━━━
if [[ -n "$SSH_CONNECTION" ]]; then
  PROMPT="%F{red}[SSH]%f $PROMPT"
fi

# ━━━━━━━ Dynamic Terminal Palette Reapply ━━━━━━━━━
if [[ $- == *i* && $(uname) == "Linux" ]]; then
  autoload -Uz add-zsh-hook

  apply_palette() {
    local seq_file="$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt"
    # Use system cat directly to bypass any alias or function override
    if [[ -r "$seq_file" ]]; then
      command cat "$seq_file"
    fi
  }

  # Apply once on startup (instant colors, no visible output)
  apply_palette &>/dev/null

  # Reapply palette silently before each prompt
  add-zsh-hook precmd apply_palette
fi
