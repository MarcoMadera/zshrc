# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Keybindings & Interactive Search Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── Keybindings for history search ──

# Standard emacs-mode arrow key support
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# vi-mode navigation keys (when in vicmd mode)
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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

# Fallback bindings 
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

