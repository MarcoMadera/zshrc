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

# ━━━━━━━ App-specific XDG Paths ━━━━━━━━━
export SEQFILE="${XDG_CACHE_HOME}/quickshell/scripts/terminal/sequences.txt"
export QML2_IMPORT_PATH="/usr/lib/qt6/qml:$QML2_IMPORT_PATH"
export QT_QML_GENERATE_QMLLS_INI=ON
export HYPRPM_USER=1
export PATH="$HOME/.npm-global/bin:$PATH"
