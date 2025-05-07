bindkey -v
typeset -A MODE_STYLES

MODE_STYLES=(
  "INSERT"  "cyan"
  "NORMAL"  "yellow" 
  "VISUAL"  "red"
  "VIS-BK"  "magenta"
)

function format_mode_indicator() {
  local mode_name="$1"
  local color="${MODE_STYLES[$mode_name]}"
  echo "%B%F{$color}%f%K{$color}%F{black}[$mode_name]%f%k%F{$color}%f%b"
}

MODE=$(format_mode_indicator "INSERT")

function update_mode_indicator() {
  local current_mode
  
  if [[ $KEYMAP == vicmd ]]; then
    if [[ $REGION_ACTIVE == 1 ]]; then
      current_mode="VISUAL"
    elif [[ $REGION_ACTIVE == 2 ]]; then
      current_mode="VIS-BK"
    else
      current_mode="NORMAL"
    fi
  else
    current_mode="INSERT"
  fi
  
  MODE=$(format_mode_indicator "$current_mode")
  
  zle reset-prompt 2>/dev/null || true
}

function visual_to_insert {
  REGION_ACTIVE=0    # Directly disable visual mode flag
  zle vi-insert      # Switch to insert mode
  update_mode_indicator # Update the mode display
}

zle -N visual_to_insert
zle -N zle-line-pre-redraw update_mode_indicator
zle -N zle-keymap-select update_mode_indicator
bindkey -M visual 'i' visual_to_insert 
