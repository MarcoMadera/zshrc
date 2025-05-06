# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Local Overrides & Machine-Specific Hooks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Hyprland auto-theming hook (if present)
[[ -f ~/.config/zshrc.d/auto-Hypr.sh ]] && source ~/.config/zshrc.d/auto-Hypr.sh

# Custom user-local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
