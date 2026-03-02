# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   External Tool Integrations (fzf, zoxide, etc.)
#   Cross-platform & XDG-friendly
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ FZF ━━━━━━━━━
if command -v fzf >/dev/null 2>&1; then
  _fzf_init="$(fzf --zsh 2>/dev/null)"
  if [[ -n "$_fzf_init" ]]; then
    eval "$_fzf_init"
  else
    # Fallback for fzf < 0.48: search known prefix locations
    case "$(uname)" in
      Darwin)
        for _d in /opt/homebrew/opt/fzf /usr/local/opt/fzf; do
          [[ -d "$_d" ]] && { _fzf_prefix="$_d"; break }
        done
        ;;
      Linux)
        for _d in /usr/share/fzf /usr/share/doc/fzf/examples; do
          [[ -d "$_d" ]] && { _fzf_prefix="$_d"; break }
        done
        ;;
    esac
    [[ -f "$_fzf_prefix/shell/key-bindings.zsh" ]] && source "$_fzf_prefix/shell/key-bindings.zsh"
    [[ -f "$_fzf_prefix/shell/completion.zsh" ]]   && source "$_fzf_prefix/shell/completion.zsh"
    unset _fzf_prefix
  fi
  unset _fzf_init

  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f"

  fh() { print -z "$(fc -l 1 | fzf --no-sort | sed 's/^ *[0-9]* *//')" }
fi

# ━━━━━━━ Bun ━━━━━━━━━
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
