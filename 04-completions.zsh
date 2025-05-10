# ───── Completion Core ─────
autoload -Uz compinit
ZCOMPDUMP_FILE="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ -n ${ZCOMPDUMP_FILE}(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

setopt COMPLETE_IN_WORD

# ───── Completion Styles ─────
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zcompcache
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' verbose yes

# ───── Fzf-tab Styles ─────
zstyle ':fzf-tab:*' command-prompt ''
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -a --icons "$realpath" 2>/dev/null || ls -la "$realpath"'
zstyle ':fzf-tab:*' fzf-preview '[[ -f ${(Q)realpath} ]] && (file ${(Q)realpath} | grep -q "^image/" && file ${(Q)realpath} || bat --color=always --style=numbers --line-range=:500 ${(Q)realpath} 2>/dev/null) || ([[ -d ${(Q)realpath} ]] && (exa -al --color=always ${(Q)realpath} 2>/dev/null || ls -al ${(Q)realpath})) || echo "Not a file or directory: ${(Q)realpath}"'

# ───── Autosuggestions ─────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
bindkey -M viins '^F' autosuggest-accept
