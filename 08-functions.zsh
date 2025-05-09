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
  if [[ $# -eq 0 ]]; then
    nvim
    return
  fi

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


# Quick stopwatch
stopwatch() {
  local start end elapsed
  start=$(date +%s.%3N)  # seconds with milliseconds

  echo "⏱ Stopwatch started. Press any key to stop..."
  read -k 1

  end=$(date +%s.%3N)
  elapsed=$(printf "%.3f" "$(echo "$end - $start" | bc)")
  echo "⏰ Elapsed: ${elapsed}s"
}

timer() {
  local secs=${1:-5}
  echo "⏳ Countdown: $secs seconds"
  while [ $secs -gt 0 ]; do
    printf "\r🕒 $secs..."
    sleep 1
    ((secs--))
  done
  echo -e "\r🔔 Time's up!         "

  if command -v afplay &>/dev/null; then
    afplay /System/Library/Sounds/Glass.aiff  # macOS default sound
  elif command -v paplay &>/dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || \
    echo -e "\a"  # Linux with PulseAudio
  else
    echo -e "\a"  # Fallback: terminal bell
  fi
}

remindme() {
  local msg="${*:-Hey, time's up!}"
  sleep 3 && \
  (command -v say >/dev/null && say "$msg") || \
  (command -v spd-say >/dev/null && spd-say "$msg") || \
  echo "$msg"
}

pwgen() {
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%&*' </dev/urandom | head -c "${1:-16}" && echo
}

alias reminders="jobs -l"
alias killreminder="kill %"

in() {
  local mins=$1; shift
  local msg="${*:-Reminder}"
  echo "⏰ I'll remind you in $mins minute(s): $msg"
  (sleep $((mins * 60)) && remindme "$msg") &
}

today() {
  date "+🗓 %A, %B %d, %Y — 🕒 %I:%M %p"
}

# Rainbow echo just because
saycolor() {
  local colors=(
    "Midnight Blue:#191970"
    "Crimson Red:#DC143C"
    "Neon Green:#39FF14"
    "Cyber Grape:#58427C"
    "Pastel Pink:#FFD1DC"
    "Royal Purple:#7851A9"
    "Solar Flare:#FF5E13"
    "Deep Teal:#014D4D"
    "Sunbeam Yellow:#FFF200"
    "Ghost White:#F8F8FF"
  )

  local choice="${colors[RANDOM % ${#colors[@]}]}"
  local name="${choice%%:*}"
  local hex="${choice##*:}"

  echo -e "🎨 Your color vibe is \033[1;38;2;${(j.:.)${(s/#/)hex#}}m$name\033[0m ($hex)"

  # Speak the vibe (macOS say or Linux spd-say)
  (command -v say >/dev/null && say "Your color is $name") || \
  (command -v spd-say >/dev/null && spd-say "Your color is $name") || \
  echo "🗣 $name"
}

whereami() {
  local host
  host=$(command -v hostname >/dev/null && hostname || echo "unknown")

  echo "🖥️  Host:      $host"
  echo "🌐 IP:        $(curl -s ifconfig.me)"
  echo "📍 Location:  $(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)"
  echo "🕰  Time:      $(date '+%A, %B %d — %H:%M %p')"
}

bless() {
  local ritual="${1:-commit}"
  shift
  local msg="🙏 Blessing this $ritual... may it be bug-free and beautiful."

  echo "$msg"

  case "$ritual" in
    commit)
      git add . && git commit -m "${*:-blessed commit}" && git push
      ;;
    build)
      echo "🧱 Building project..."
      bun run build || echo "🚨 Build failed, may the gods be displeased"
      ;;
    sync)
      echo "🌍 Syncing dotfiles..."
      rsync -avh --exclude='.git/' ~/dotfiles/ /repos/zshrc/
      ;;
    theme)
      echo "🎨 Applying your sacred theme..."
      ~/.config/hypr/custom/scripts/applycolor-fast.sh
      ;;
    *)
      echo "😇 No ritual defined for '$ritual', but your intent is noted."
      ;;
  esac
}
