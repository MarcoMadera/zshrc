# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Prompt Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Enable prompt variable expansion
setopt prompt_subst

# ━━━━━━━ Git Info (vcs_info) ━━━━━━━━━
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{cyan}(%f%F{blue}%b%F{cyan})%f'
zstyle ':vcs_info:git:*' actionformats '%F{cyan}(%f%F{blue}%b%F{red}|%a%F{cyan})%f'
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

# ━━━━━━━ Prompt Segments ━━━━━━━━━

# Python virtualenv
virtualenv_info() {
  [[ -n "$VIRTUAL_ENV" ]] && echo "%F{yellow}[$(basename "$VIRTUAL_ENV")]%f "
}

# Root user warning
root_indicator() {
  [[ $UID -eq 0 ]] && echo "%F{red}[ROOT]%f "
}

# Background job count
background_jobs() {
  local c=$(jobs -p | wc -l)
  (( c > 0 )) && echo "%F{magenta}[Jobs:$c]%f "
}

# ━━━━━━━ Final Prompt ━━━━━━━━━
PROMPT='${MODE} $(virtualenv_info)$(root_indicator)$(background_jobs)%F{yellow}%~%f ${vcs_info_msg_0_} %F{blue}❯%f '
