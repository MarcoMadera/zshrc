# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   External Tool Integrations (fzf, zoxide, etc.)
#   Cross-platform & XDG-friendly
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ Zoxide ━━━━━━━━━
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# ━━━━━━━ FZF ━━━━━━━━━
if command -v fzf >/dev/null 2>&1; then
  # Detect OS for fzf extra scripts
  case "$(uname)" in
    Darwin)
      FZF_PREFIX="$(brew --prefix fzf 2>/dev/null)"
      ;;
    Linux)
      FZF_PREFIX="/usr/share/fzf"
      ;;
    *)
      FZF_PREFIX=""
      ;;
  esac

  # Source keybindings and completions if available
  [[ -f "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -f "$FZF_PREFIX/shell/completion.zsh" ]] && source "$FZF_PREFIX/shell/completion.zsh"

  # FZF UI defaults
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f"

  # Fuzzy history search function
  fh() {
    print -z "$(history | cut -c8- | fzf --no-sort)"
  }
fi
