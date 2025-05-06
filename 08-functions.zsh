# ━━━━━━━ Superuser ━━━━━━━━━
please() { 
  if [[ -z "$1" ]]; then
    sudo "$(fc -ln -1)"
  else
    sudo "$@"
  fi
}

# ━━━━━━━ File Manager ━━━━━━━━━
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if [[ -f "$tmp" ]]; then
    cwd="$(<"$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
}


n() {
  local tmp cwd
  tmp="$(mktemp -t "nvim-cwd.XXXXXX")"
  nvim "$@" -c "silent !pwd > $tmp" -c 'autocmd VimLeavePre * silent! !pwd > '"$tmp" -c 'autocmd VimLeave * qa!'
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

cat() {
  if [[ "$1" == "$SEQFILE" ]]; then
    command cat "$@"
  elif command -v bat &>/dev/null; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}

# ━━━━━━━ Directory Shortcuts ━━━━━━━━━
mkcd() { mkdir -p "$1" && cd "$1" }

tmpd() { 
  local dir=$(mktemp -d)
  echo "Created temporary directory: $dir"
  cd "$dir"
}

dirsize() { du -sh "${1:-.}" }

# ━━━━━━━ File/Content Search ━━━━━━━━━
findtext() { 
  if command -v rg >/dev/null 2>&1; then
    rg --color=auto "$@"
  else
    grep -r --color=auto "$@" .
  fi
}

findfile() {
  if command -v fd >/dev/null 2>&1; then
    fd "$@"
  else
    find . -name "*$1*" -type f
  fi
}

# ━━━━━━━ File Utils ━━━━━━━━━
extract() {
  # Supports: .tar.gz, .zip, .7z, .rar, .bz2, .gz, .Z, .tgz, .tbz2, etc.
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz)  tar xzf $1 ;;
      *.bz2)     bunzip2 $1 ;;
      *.rar)     unrar e $1 ;;
      *.gz)      gunzip $1 ;;
      *.tar)     tar xf $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.zip)     unzip $1 ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1 ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ━━━━━━━ Web Utilities ━━━━━━━━━
weather() { curl -s "wttr.in/${1:-}" | head -n7 }
cheat() { curl -s "cheat.sh/$1" }
