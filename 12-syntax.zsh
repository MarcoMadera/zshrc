# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Syntax Highlighting & Autosuggestions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── Autosuggestions ──
# Zinit handles this plugin in 03-zinit.zsh already,

# Catppuccin Mocha — Overlay0 for unobtrusive ghost text
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# ── Syntax Highlighting ──
# This plugin must be loaded **last**
zinit light zsh-users/zsh-syntax-highlighting

# Catppuccin Mocha highlight styles
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[path]='fg=#89dceb'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cba6f7,bold'

