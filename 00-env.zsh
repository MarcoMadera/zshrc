# ━━━━━━━ XDG Base Dirs (Cross-platform) ━━━━━━━━━
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure the folders exist
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"
mkdir -p "$XDG_CACHE_HOME/zsh"

# ━━━━━━━ Frameworks ━━━━━━━━━
export ZSH="$HOME/.oh-my-zsh"
export ZINIT_HOME="$XDG_DATA_HOME/zinit"

export LANG=en_US.UTF-8
export BAT_PAGER="less"
export EDITOR="nvim"
