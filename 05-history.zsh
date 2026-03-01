# ━━━━━━━ History Options ━━━━━━━━━
setopt share_history            # Share history between sessions (implies append + inc_append)
setopt extended_history         # Timestamp each command
setopt hist_expire_dups_first  # Expire duplicate entries first
setopt hist_ignore_dups        # Don’t record duplicates
setopt hist_ignore_all_dups    # Remove all duplicates in history
setopt hist_find_no_dups       # No duplicate matches when searching
setopt hist_ignore_space       # Ignore commands starting with space
setopt hist_reduce_blanks      # Remove superfluous blanks
setopt hist_verify             # Don’t execute history line right away
setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus
setopt extended_glob glob_dots numeric_glob_sort no_case_glob

# ━━━━━━━ History File Location ━━━━━━━━━
HISTFILE="$XDG_CACHE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# ━━━━━━━ Word Navigation ━━━━━━━━━
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
