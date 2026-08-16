# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Keybindings & Interactive Search Enhancements
#
#   Every key binding in this config belongs in this file (or in 06-vi-mode.ps1
#   *after* the EditMode switch). `Set-PSReadLineOption -EditMode` resets the
#   whole key table to that mode's defaults, so anything bound in an earlier
#   module is silently thrown away.
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$viInsert = if ($global:PWSHRC_CONFIG.EditMode -eq 'Vi') { 'Insert' } else { $null }

function script:Bind {
  param([string]$Chord, [string]$Function, [string]$ViMode)

  $p = @{ Chord = $Chord; Function = $Function }
  if ($ViMode) { $p.ViMode = $ViMode }
  Set-PSReadLineKeyHandler @p -ErrorAction SilentlyContinue
}

# ── History navigation ──
# history-substring-search-up/down: PSReadLine's HistorySearchBackward matches
# on the text already typed, which is the same behaviour.
Bind 'UpArrow'   'HistorySearchBackward' $viInsert
Bind 'DownArrow' 'HistorySearchForward'  $viInsert
Bind 'Ctrl+p'    'HistorySearchBackward' $viInsert
Bind 'Ctrl+n'    'HistorySearchForward'  $viInsert

if ($global:PWSHRC_CONFIG.EditMode -eq 'Vi') {
  Bind 'UpArrow'   'HistorySearchBackward' 'Command'
  Bind 'DownArrow' 'HistorySearchForward'  'Command'
  # k/j in vicmd — the zsh config remaps them to history search
  Bind 'k' 'HistorySearchBackward' 'Command'
  Bind 'j' 'HistorySearchForward'  'Command'
}

# ── Insert-mode essentials lost with `bindkey -v` ──
Bind 'Backspace' 'BackwardDeleteChar'  $viInsert
Bind 'Ctrl+h'    'BackwardDeleteChar'  $viInsert
Bind 'Ctrl+w'    'BackwardKillWord'    $viInsert
Bind 'Ctrl+u'    'BackwardDeleteLine'  $viInsert
Bind 'Ctrl+k'    'ForwardDeleteLine'   $viInsert
Bind 'Ctrl+a'    'BeginningOfLine'     $viInsert
Bind 'Ctrl+e'    'EndOfLine'           $viInsert
Bind 'Ctrl+l'    'ClearScreen'         $viInsert

# ── Autosuggestion accept ──
# bindkey -M viins '^F' autosuggest-accept
Bind 'Ctrl+f' 'AcceptSuggestion' $viInsert

# Right arrow accepts the suggestion at end of line, otherwise moves the cursor
Set-PSReadLineKeyHandler -Chord 'RightArrow' -ViMode Insert `
  -BriefDescription 'ForwardCharOrAcceptSuggestion' `
  -LongDescription 'Move right, or accept the inline suggestion at end of line' `
  -ScriptBlock {
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -lt $line.Length) {
      [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar()
    } else {
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    }
  }

# ── fzf integration (fzf-tab, Ctrl-R, Ctrl-T) ──
# PSFzf is imported on the first press of any of these rather than at startup,
# where it costs ~560ms. Initialize-PwshRcPSFzf is defined in 02-modules.ps1.
if ($global:PWSHRC_PSFZF_LAZY) {

  Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -BriefDescription 'FuzzyHistory' `
    -LongDescription 'Fuzzy-search command history (loads PSFzf on first use)' -ScriptBlock {
      if (Initialize-PwshRcPSFzf) { Invoke-FuzzyHistory }
      else { [Microsoft.PowerShell.PSConsoleReadLine]::ReverseSearchHistory() }
    }

  Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -BriefDescription 'FuzzyFile' `
    -LongDescription 'Fuzzy-pick a path into the buffer (loads PSFzf on first use)' -ScriptBlock {
      if (Initialize-PwshRcPSFzf) { Invoke-FuzzyEdit }
    }

  Set-PSReadLineKeyHandler -Key Tab -BriefDescription 'FuzzyTabExpansion' `
    -LongDescription 'Tab completion through fzf (loads PSFzf on first use)' -ScriptBlock {
      # Set-PsFzfOption -TabExpansion rebinds Tab to PSFzf from here on, so this
      # handler runs at most once; serve that first press with the plain menu.
      [void](Initialize-PwshRcPSFzf)
      [Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
    }

} else {
  # No fzf — PSReadLine's own menu, the zstyle ':completion:*' menu select
  Bind 'Tab'    'MenuComplete'          $null
  Bind 'Ctrl+r' 'ReverseSearchHistory'  $viInsert
}

# ── Quality-of-life additions Windows users expect ──
Bind 'Ctrl+LeftArrow'  'BackwardWord' $viInsert
Bind 'Ctrl+RightArrow' 'ForwardWord'  $viInsert
Bind 'Alt+d'           'KillWord'     $viInsert
Bind 'Ctrl+z'          'Undo'         $viInsert

# F7 — browse history. Out-GridView is not in PS 7 by default, so fzf gets
# first refusal and the binding is skipped entirely when neither is available.
if (Test-PwshRcTool 'fzf') {
  Set-PSReadLineKeyHandler -Key F7 -BriefDescription 'HistoryList' `
    -LongDescription 'Pick a command from history with fzf' -ScriptBlock {
      $selection = Get-History | Select-Object -ExpandProperty CommandLine -Unique |
                   fzf --no-sort --tac --height 40% --layout=reverse --border
      if ($selection) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
      }
    }
} elseif (Get-Command Out-GridView -ErrorAction SilentlyContinue) {
  Set-PSReadLineKeyHandler -Key F7 -BriefDescription 'HistoryList' `
    -LongDescription 'Show command history in a grid' -ScriptBlock {
      $selection = Get-History | Select-Object -ExpandProperty CommandLine -Unique |
                   Out-GridView -Title 'History' -OutputMode Single
      if ($selection) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
      }
    }
}
