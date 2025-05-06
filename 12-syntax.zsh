# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Syntax Highlighting & Autosuggestions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── Autosuggestions ──
# Zinit handles this plugin in 03-zinit.zsh already,

# Customize ghost suggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# ── Syntax Highlighting ──
# This plugin must be loaded **last**
zinit light zsh-users/zsh-syntax-highlighting

# Customize highlight styles
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=red'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta,bold'

