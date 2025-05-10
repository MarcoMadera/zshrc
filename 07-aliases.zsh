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
# Use exa if available, otherwise fallback to standard ls
if command -v exa &>/dev/null; then
  alias ls='exa'
  alias l='exa -lbF --git'           # Long format, Git status
  alias ll='exa -laBF --git'          # All files, long format, Git status
  alias lt='exa -lbF --git --tree --level=3'  # Tree view
else
  alias ll='ls -lah'
  alias la='ls -a'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System & Network
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
alias cls='clear'
alias h='history'
alias ports='ss -tulanp'
alias myip='curl -s https://ipinfo.io/ip'
alias ip='curl -s https://ipinfo.io/ip'  # Duplicate of myip

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
alias zshrc='${EDITOR:-nvim} "${ZSHRC_DIR:-$HOME/.zshrc}"'
alias reload='exec zsh'

# ━━━━━━━ Utils ━━━━━━━━━
alias myip='curl -s https://ipinfo.io/ip'
alias ip='curl -s https://ipinfo.io/ip'
