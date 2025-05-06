# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Keybindings & Interactive Search Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── Keybindings for history search ──

# Standard emacs-mode arrow key support
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# vi-mode navigation keys (when in vicmd mode)
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Fallback bindings 
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
