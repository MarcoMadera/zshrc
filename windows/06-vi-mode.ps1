# ━━━━━━━ Vi Mode ━━━━━━━━━
# `bindkey -v` equivalent. PSReadLine's vi implementation covers the motions and
# operators; what it lacks — a mode indicator wired into the prompt and the
# surround verbs — is rebuilt below.

if ($global:PWSHRC_CONFIG.EditMode -eq 'Vi') {
  Set-PSReadLineOption -EditMode Vi
} else {
  Set-PSReadLineOption -EditMode Emacs
}

# ──────────── Mode Indicator ────────────
# 11-prompt.ps1 turns this string into the coloured pill. Keeping the *name*
# here (rather than the rendered pill, as the zsh side does) means the palette
# stays owned by the prompt module.
$global:PWSHRC_MODE = 'INSERT'

function global:Set-PwshRcCursor {
  param([ValidateSet('beam', 'block')][string]$Shape)
  $e = [char]27
  switch ($Shape) {
    'beam'  { [Console]::Write("$e[6 q") }   # steady bar   — insert
    'block' { [Console]::Write("$e[2 q") }   # steady block — normal
  }
}

if ($global:PWSHRC_CONFIG.EditMode -eq 'Vi') {
  Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler {
    param($mode)

    if ($mode -eq 'Command') {
      $global:PWSHRC_MODE = 'NORMAL'
      Set-PwshRcCursor block
    } else {
      $global:PWSHRC_MODE = 'INSERT'
      Set-PwshRcCursor beam
    }

    # Redraw so the mode pill updates in place, the way zle reset-prompt does.
    if ($global:PWSHRC_CONFIG.EnableModePill) {
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
  }
}

# ──────────── Surround ────────────
# Reimplementation of the _sur_* helpers: ds<d> deletes a surrounding pair,
# cs<old><new> replaces it, ys<d> wraps the whole line.

$global:PWSHRC_SURROUND_PAIRS = @{
  '(' = ')'; ')' = ')'
  '[' = ']'; ']' = ']'
  '{' = '}'; '}' = '}'
  '<' = '>'; '>' = '>'
  '"' = '"'
  "'" = "'"
  '`' = '`'
}

function script:Get-SurroundPair {
  param([string]$Key)

  if (-not $global:PWSHRC_SURROUND_PAIRS.ContainsKey($Key)) { return $null }

  $close = $global:PWSHRC_SURROUND_PAIRS[$Key]
  # Closing keys map to themselves above; recover the opener for those.
  $open = switch ($Key) {
    ')' { '(' }
    ']' { '[' }
    '}' { '{' }
    '>' { '<' }
    default { $Key }
  }
  return @{ Open = $open; Close = $close }
}

# Port of _sur_find: locate the pair enclosing the cursor. Returns the indices
# of the opening and closing delimiters, or $null when the cursor is not inside
# one. Nesting is respected for asymmetric pairs.
function script:Find-SurroundRange {
  param([string]$Key, [string]$Buffer, [int]$Cursor)

  $pair = Get-SurroundPair $Key
  if (-not $pair) { return $null }

  $open = $pair.Open; $close = $pair.Close
  $len = $Buffer.Length
  $L = -1; $R = -1

  if ($open -eq $close) {
    # Symmetric delimiters cannot nest: scan outward from the cursor.
    for ($i = [Math]::Min($Cursor, $len - 1); $i -ge 0; $i--) {
      if ($Buffer[$i] -eq $open) { $L = $i; break }
    }
    for ($i = $Cursor + 1; $i -lt $len; $i++) {
      if ($Buffer[$i] -eq $close) { $R = $i; break }
    }
  } else {
    for ($i = [Math]::Min($Cursor, $len - 1); $i -ge 0; $i--) {
      if ($Buffer[$i] -eq $open) { $L = $i; break }
    }
    if ($L -ge 0) {
      $nest = 1
      for ($i = $L + 1; $i -lt $len; $i++) {
        if     ($Buffer[$i] -eq $open)  { $nest++ }
        elseif ($Buffer[$i] -eq $close) { $nest--; if ($nest -eq 0) { $R = $i; break } }
      }
    }
  }

  if ($L -ge 0 -and $R -gt $L) { return @{ Start = $L; End = $R } }
  return $null
}

# Port of _sur_readkey — grab one more keystroke to name the delimiter.
function script:Read-SurroundKey {
  $k = [Console]::ReadKey($true)
  if ($k.KeyChar -eq [char]27 -or $k.KeyChar -eq [char]0) { return $null }  # Esc aborts
  return [string]$k.KeyChar
}

function script:Get-Buffer {
  $line = $null; $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  return @{ Line = $line; Cursor = $cursor }
}

if ($global:PWSHRC_CONFIG.EditMode -eq 'Vi' -and $global:PWSHRC_CONFIG.EnableSurround) {

  # ds" — delete the surrounding pair
  Set-PSReadLineKeyHandler -Chord 'd,s' -ViMode Command `
    -BriefDescription 'SurroundDelete' -LongDescription 'Delete the surrounding delimiter pair' `
    -ScriptBlock {
      $target = Read-SurroundKey
      if (-not $target) { return }

      $b = Get-Buffer
      $r = Find-SurroundRange $target $b.Line $b.Cursor
      if (-not $r) { return }

      $new = $b.Line.Substring(0, $r.Start) +
             $b.Line.Substring($r.Start + 1, $r.End - $r.Start - 1) +
             $b.Line.Substring($r.End + 1)

      [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $b.Line.Length, $new)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($r.Start)
    }

  # cs"' — change the surrounding pair
  Set-PSReadLineKeyHandler -Chord 'c,s' -ViMode Command `
    -BriefDescription 'SurroundChange' -LongDescription 'Replace the surrounding delimiter pair' `
    -ScriptBlock {
      $target = Read-SurroundKey
      if (-not $target) { return }

      $b = Get-Buffer
      $r = Find-SurroundRange $target $b.Line $b.Cursor
      if (-not $r) { return }

      $replacement = Read-SurroundKey
      if (-not $replacement) { return }
      $pair = Get-SurroundPair $replacement
      if (-not $pair) { return }

      $new = $b.Line.Substring(0, $r.Start) + $pair.Open +
             $b.Line.Substring($r.Start + 1, $r.End - $r.Start - 1) + $pair.Close +
             $b.Line.Substring($r.End + 1)

      [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $b.Line.Length, $new)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($r.Start)
    }

  # ys" — wrap the whole line
  Set-PSReadLineKeyHandler -Chord 'y,s' -ViMode Command `
    -BriefDescription 'SurroundAdd' -LongDescription 'Wrap the line in a delimiter pair' `
    -ScriptBlock {
      $key = Read-SurroundKey
      if (-not $key) { return }
      $pair = Get-SurroundPair $key
      if (-not $pair) { return }

      $b = Get-Buffer
      $new = $pair.Open + $b.Line + $pair.Close

      [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $b.Line.Length, $new)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($b.Cursor + $pair.Open.Length)
    }
}

# Start every line in insert mode with a beam cursor, matching _zle_line_init.
Set-PwshRcCursor beam
