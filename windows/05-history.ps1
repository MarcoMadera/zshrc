# ━━━━━━━ History ━━━━━━━━━
# PSReadLine's history file is the analogue of HISTFILE; point it at the XDG
# cache dir instead of the default AppData\Roaming location.

$_histDir = Join-Path $env:XDG_CACHE_HOME 'pwsh'
if (-not (Test-Path -LiteralPath $_histDir)) {
  New-Item -ItemType Directory -Path $_histDir -Force | Out-Null
}

Set-PSReadLineOption -HistorySavePath (Join-Path $_histDir 'history.txt')

# SAVEHIST=50000
Set-PSReadLineOption -MaximumHistoryCount 50000

# share_history — every shell appends and re-reads the same file
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally

# hist_ignore_dups / hist_ignore_all_dups / hist_find_no_dups
Set-PSReadLineOption -HistoryNoDuplicates

# hist_verify — recalled lines land on the command line, they do not auto-run.
# This is PSReadLine's default; the option below is the searching half.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySearchCaseSensitive:$false

# hist_ignore_space, plus keeping secrets out of the on-disk history.
# PSReadLine's hook returns MemoryOnly/SkipAdding instead of zsh's setopt.
Set-PSReadLineOption -AddToHistoryHandler {
  param($line)

  # hist_ignore_space
  if ($line -match '^\s') { return $false }

  # Trivial single-token commands are noise in a 50k history
  if ($line.Trim().Length -le 2) { return $false }

  # Never persist anything that looks like a credential
  $sensitive = 'password|passwd|secret|token|apikey|api_key|credential|-AsPlainText|BW_SESSION'
  if ($line -match $sensitive) {
    return [Microsoft.PowerShell.AddToHistoryOption]::MemoryOnly
  }

  return $true
}

# ━━━━━━━ Word Navigation ━━━━━━━━━
# WORDCHARS='*?_-.[]~&;!#$%^(){}<>' — PSReadLine takes the inverse: the
# characters that *delimit* words.
Set-PSReadLineOption -WordDelimiters ' /\()"''-:,.;<>~!@#$%^&*|+=[]{}~?'

# ━━━━━━━ auto_cd / auto_pushd ━━━━━━━━━
# `cd -` support: PowerShell 6+ has it natively via Set-Location -, and
# 07-aliases.ps1 maps `back` onto it.
