# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   UI Tweaks & Visual Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ Load Color Definitions ━━━━━━━━━
autoload -Uz colors && colors


# ━━━━━━━ Dynamic Terminal Palette Reapply ━━━━━━━━━
if [[ $- == *i* && $(uname) == "Linux" ]]; then
  autoload -Uz add-zsh-hook

  apply_palette() {
    # Use system cat directly to bypass any alias or function override
    if [[ -r "$SEQFILE" ]]; then
      command cat "$SEQFILE"
    fi
  }

  # Apply once on startup (instant colors, no visible output)
  apply_palette &>/dev/null

  # Reapply palette silently before each prompt
  add-zsh-hook precmd apply_palette
fi
