# ━━━━━━━ Git Aliases ━━━━━━━━━
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gl='git log --oneline'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gf='git fetch'
alias gr='git rebase'
alias grs='git reset'

# ━━━━━━━ Navigation ━━━━━━━━━
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias back='cd -'

# ━━━━━━━ Filesystem & Shell ━━━━━━━━━
alias ll='ls -lah'
alias la='ls -a'
alias cls='clear'
alias h='history'
alias ports='ss -tulanp'

# ━━━━━━━ Config & Editor Shortcuts ━━━━━━━━━
alias zshrc='${EDITOR:-nvim} "${ZSHRC_DIR:-$HOME/.zshrc}"'
alias reload='exec zsh'

# ━━━━━━━ Utils ━━━━━━━━━
alias myip='curl -s https://ipinfo.io/ip'
