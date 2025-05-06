# ━━━━━━━ Zinit Plugin Manager ━━━━━━━━━

if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
  print -P "%F{yellow}Installing Zinit...%f"
  mkdir -p "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
fi

source "$ZINIT_HOME/bin/zinit.zsh"

# ━━━━━━━ Zinit Plugins ━━━━━━━━━
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light hlissner/zsh-autopair
zinit light zsh-users/zsh-history-substring-search
