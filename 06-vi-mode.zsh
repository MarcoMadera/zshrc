bindkey -v

# Default mode
MODE="[%F{green}INSERT%f]"

function update_mode_indicator {
  if [[ $KEYMAP == vicmd && $REGION_ACTIVE == 1 ]]; then
    MODE="[%F{magenta}VISUAL%f]"
  elif [[ $KEYMAP == vicmd && $REGION_ACTIVE == 2 ]]; then
    MODE="[%F{red}VIS-BK%f]"
  elif [[ $KEYMAP == vicmd ]]; then
    MODE="[%F{blue}NORMAL%f]"
  else
    MODE="[%F{green}INSERT%f]"
  fi
  zle reset-prompt 2>/dev/null || true
}

function visual_to_insert {
  REGION_ACTIVE=0    # Directly disable visual mode flag
  zle vi-insert      # Switch to insert mode
  update_mode_indicator # Update the mode display
}

zle -N visual_to_insert
zle -N zle-line-pre-redraw update_mode_indicator
bindkey -M visual 'i' visual_to_insert 
