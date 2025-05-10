# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Administration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
please() { 
  if [[ -z "$1" ]]; then
    sudo "$(fc -ln -1)"
  else
    sudo "$@"
  fi
}

whereami() {
  local host
  host=$(command -v hostname >/dev/null && hostname || echo "unknown")

  echo "🖥️  Host:      $host"
  echo "🌐 IP:        $(curl -s ifconfig.me)"
  echo "📍 Location:  $(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)"
  echo "🕰  Time:      $(date '+%A, %B %d — %H:%M %p')"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Application Wrappers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Directory Management
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
mkcd() { mkdir -p "$1" && cd "$1" }

tmpd() { 
  local dir=$(mktemp -d)
  echo "Created temporary directory: $dir"
  cd "$dir"
}

dirsize() { du -sh "${1:-.}" }

up() {
  local count=${1:-1}
  local path=""
  for i in $(seq 1 $count); do
    path+="../"
  done
  cd "$path"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Search Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File Operations
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

targz() {
  if [[ -n "$1" && -n "$2" ]]; then
    tar -zcvf "$1.tar.gz" "$2"
  else
    echo "Usage: targz <archive_name_no_extension> <file_or_directory_to_compress>"
    return 1
  fi
}

zipit() {
  if [[ -n "$1" && -n "$2" ]]; then
    zip -r "$1.zip" "$2"
  else
    echo "Usage: zipit <archive_name_no_extension> <file_or_directory_to_compress>"
    return 1
  fi
}

mkexe() {
  if [[ -f "$1" ]]; then
    chmod +x "$1"
    echo "Made '$1' executable."
  else
    echo "File '$1' not found."
    return 1
  fi
}

bak() {
  if [[ -z "$1" ]]; then
    echo "Usage: bak <filename>"
    return 1
  fi
  local timestamp=$(date +%Y%m%d-%H%M%S)
  cp -a "$1" "${1}.bak.${timestamp}" && echo "Backed up $1 to ${1}.bak.${timestamp}"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Web Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
weather() { curl -s "wttr.in/${1:-}" | head -n7 }
cheat() { curl -s "cheat.sh/$1" }

# Quick stopwatch
headers() {
  if [[ -n "$1" ]]; then
    curl -sIL "$1"
  else
    echo "Usage: headers <URL>"
    return 1
  fi
}

serve() {
  local port="${1:-8000}"
  local ip_addr=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || hostname -I | awk '{print $1}') # Tries for eth0, then hostname -I
  echo "Serving current directory ($PWD) at http://${ip_addr}:${port}"
  # Try python3 http.server, then python SimpleHTTPServer
  if command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v python &>/dev/null; then
    python -m SimpleHTTPServer "$port"
  else
    echo "Python not found. Cannot start HTTP server."
    return 1
  fi
}

qr() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: qr <text>"
    return 1
  fi
  curl "qrenco.de/$*"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Time Management
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Utility Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
pwgen() {
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%&*' </dev/urandom | head -c "${1:-16}" && echo
}

calc() {
  echo "scale=4; $@" | bc -l
}

bless() {
  if [[ $# -eq 0 ]]; then
    echo "😇 Usage: bless <command> [args...]"
    return 1
  fi

  echo "🙏 Blessing this command with divine energy:"
  echo "🧾 → $*"
  echo "Proceed? [y/N]"
  read -q || { echo "❌ Aborted"; return 1; }

  echo -e "\n✨ Executing..."
  "$@"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "🕊️  Success. The gods smile upon your work."
  else
    echo "💀 Something broke. Offer a sacrifice or debug it yourself."
  fi

  return $exit_code
}

coinflip() {
  local result=$((RANDOM % 2))
  if [[ $result -eq 0 ]]; then
    echo "🪙 Heads – go for it."
  else
    echo "🪙 Tails – abort mission."
  fi
}

shouldi() {
  local action="${*:-do this}"
  local verdicts=("Yes." "No." "Absolutely." "Hell no." "Try again later." "Flip a coin.")
  echo "🤔 Should you $action?"
  echo "👉 ${verdicts[RANDOM % ${#verdicts[@]}]}"
}

breathe() {
  local cycles=${1:-3}
  local inhale=${2:-4}
  local hold=${3:-7} 
  local exhale=${4:-8}
  
  echo "🧘 Beginning $cycles breathing cycles..."
  echo "    Inhale: $inhale seconds"
  echo "    Hold: $hold seconds"
  echo "    Exhale: $exhale seconds"
  
  for ((i=1; i<=cycles; i++)); do
    echo -n "Cycle $i: "
    echo -n "Inhale... "
    for ((j=inhale; j>0; j--)); do
      echo -n "$j "
      sleep 1
    done
    
    echo -n "Hold... "
    for ((j=hold; j>0; j--)); do
      echo -n "$j "
      sleep 1
    done
    
    echo -n "Exhale... "
    for ((j=exhale; j>0; j--)); do
      echo -n "$j "
      sleep 1
    done
    echo
  done
  
  echo "✨ Breathing complete. Feel centered."
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FZF Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if command -v fzf &>/dev/null; then
  # Fuzzy find in command history
  fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
  }
  
  # Fuzzy find files and open with $EDITOR (uses fd if available)
  fe() {
    local file
    if command -v fd &>/dev/null; then
      file=$(fd --type f . --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    else
      file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    fi
    if [[ -n "$file" ]]; then
      ${EDITOR:-nvim} "$file"
    fi
  }
  
  # Fuzzy find directories and cd
  fcd() {
    local dir
    if command -v fd &>/dev/null; then
      dir=$(fd --type d . --hidden --exclude .git | fzf)
    else
      dir=$(find . -type d -not -path '*/\.git/*' -print 2>/dev/null | fzf)
    fi
    if [[ -n "$dir" ]]; then
      cd "$dir"
    fi
  }
fi
