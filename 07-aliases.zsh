# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Basic Git Operations
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'

# Branching and Navigation
alias gco='git checkout'
alias gb='git branch'

# Viewing Changes
alias gd='git diff'
alias gl='git log --oneline'
alias glg='git log --stat --max-count=10'
alias glog='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias lol='git log --oneline --graph --decorate'

# Advanced Operations
alias gr='git rebase'
alias grs='git reset'
alias gundo='git reset --soft HEAD~1'
alias gamend='git commit --amend --no-edit'

# Stash Management
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsta='git stash apply'
alias gstd='git stash drop'

# Git Helpers
alias galias="alias | grep 'git '"

# bitwwarden
alias bwunlock='bw unlock --raw > ~/.cache/bw_session'
alias bwsession='export BW_SESSION=$(cat ~/.cache/bw_session)'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Navigation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias back='cd -'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File Listing
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Use eza (maintained exa fork) if available, fall back to exa, then system ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias l='eza -lbF --git'
  alias ll='eza -laBF --git'
  alias lt='eza -lbF --git --tree --level=3'
elif command -v exa &>/dev/null; then
  alias ls='exa --icons'
  alias l='exa -lbF --git'
  alias ll='exa -laBF --git'
  alias lt='exa -lbF --git --tree --level=3'
else
  case "$(uname)" in
    Darwin) alias ls='ls -lahG' ;;
    Linux)  alias ls='ls --color=auto' ;;
  esac
fi


# ━━━━━━━ OS-specific Aliases ━━━━━━━━━

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System & Network
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
alias cls="clear && printf '\e[3J'"
alias h='history'
alias ports='ss -tulanp'
alias myip='curl -s https://ipinfo.io/ip'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
alias zshrc='${EDITOR:-nvim} "${ZSHRC_DIR:-$HOME/.zshrc}"'
alias reload='exec zsh'

# ━━━━━━━ Utils ━━━━━━━━━
alias reminders="jobs -l"
alias killreminder="kill %"

# ━━━━━━━ Zoxide ━━━━━━━━━
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi
