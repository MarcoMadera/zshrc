# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Keybindings & Interactive Search Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── History navigation (viins + vicmd) ──

bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M viins '^[OA' history-substring-search-up   # application cursor keys
bindkey -M viins '^[OB' history-substring-search-down

bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down
bindkey -M vicmd '^[OA' history-substring-search-up
bindkey -M vicmd '^[OB' history-substring-search-down
bindkey -M vicmd 'k'    history-substring-search-up
bindkey -M vicmd 'j'    history-substring-search-down

# ── Insert-mode essentials lost with bindkey -v ──
bindkey -M viins '^?'  backward-delete-char          # backspace
bindkey -M viins '^H'  backward-delete-char          # ctrl+backspace
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^K'  kill-line
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^R'  history-incremental-search-backward

bindkey -M vicmd 'ds' surround_delete       # ds" to delete surroundings
bindkey -M vicmd 'cs' surround_change       # cs"' to change from " to '
bindkey -M vicmd 'ys' surround_add_normal   # ys" to add surroundings
bindkey -M visual 'S'  surround_add_visual  # S" to add surroundings

bindkey -M visual 'sd' surround_delete
bindkey -M visual 'sr' surround_change
bindkey -M visual 'sa' surround_add_visual

bindkey -M visual 'i"' surround_vi_dquote
bindkey -M visual 'a"' surround_va_dquote
bindkey -M visual "i'" surround_vi_squote
bindkey -M visual "a'" surround_va_squote
bindkey -M visual "i\`" surround_vi_btick
bindkey -M visual "a\`" surround_va_btick
bindkey -M visual "i(" surround_vi_paren
bindkey -M visual "i)" surround_vi_paren
bindkey -M visual "a(" surround_va_paren
bindkey -M visual "a)" surround_va_paren
bindkey -M visual "i[" surround_vi_bracket
bindkey -M visual "i]" surround_vi_bracket
bindkey -M visual "a[" surround_va_bracket
bindkey -M visual "a]" surround_va_bracket
bindkey -M visual "i{" surround_vi_brace
bindkey -M visual "i}" surround_vi_brace
bindkey -M visual "a{" surround_va_brace
bindkey -M visual "a}" surround_va_brace
bindkey -M visual "i<" surround_vi_angle
bindkey -M visual "i>" surround_vi_angle
bindkey -M visual "a<" surround_va_angle
bindkey -M visual "a>" surround_va_angle

bindkey -M viins '^P' history-substring-search-up
bindkey -M viins '^N' history-substring-search-down

