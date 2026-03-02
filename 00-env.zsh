# ━━━━━━━ XDG Base Dirs (Cross-platform) ━━━━━━━━━
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Ensure the folders exist
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME/zsh"

# ━━━━━━━ Plugin Manager ━━━━━━━━━
export ZINIT_HOME="$XDG_DATA_HOME/zinit"

export LANG=en_US.UTF-8
export BAT_PAGER="less"
export EDITOR="nvim"

# ━━━━━━━ App-specific XDG Paths ━━━━━━━━━
export SEQFILE="${XDG_STATE_HOME}/quickshell/user/generated/terminal/sequences.txt"
export BUN_INSTALL="$HOME/.bun"
export QML2_IMPORT_PATH="/usr/lib/qt6/qml:$QML2_IMPORT_PATH"
export QT_QML_GENERATE_QMLLS_INI=ON
export Qt6_DIR="$HOME/Qt/6.10.1/macos/lib/cmake/Qt6"
export QMAKE="$HOME/Qt/6.10.1/macos/bin/qmake"
export HYPRPM_USER=1
export KITTY_CONFIG_DIRECTORY="$HOME/.config/kitty"

[ -n "$KITTY_WINDOW_ID" ] && printf '\033]30001\033\\'
