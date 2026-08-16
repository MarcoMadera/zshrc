# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   External Tool Integrations (fzf, zoxide, bun)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━ FZF ━━━━━━━━━
if (Test-PwshRcTool 'fzf') {
  $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border'

  if (Test-PwshRcTool 'fd') {
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
  } else {
    # No `find` on stock Windows; PowerShell does the walking instead.
    $env:FZF_DEFAULT_COMMAND = 'pwsh -NoProfile -Command "Get-ChildItem -Recurse -File -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName"'
  }

  # fh — put a history entry on the command line without running it.
  # print -z has no analogue, so the line is inserted into the PSReadLine buffer.
  function global:fh {
    $cmd = Get-History | Select-Object -ExpandProperty CommandLine -Unique | fzf --no-sort --tac
    if ($cmd) {
      [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert($cmd)
    }
  }
}

# ━━━━━━━ Zoxide ━━━━━━━━━
# Initialised in 07-aliases.ps1 alongside the `cd` override, matching the zsh
# layout where zoxide lives at the bottom of the aliases file.

# ━━━━━━━ Bun ━━━━━━━━━
$_bunCompletions = Join-Path $env:BUN_INSTALL '_bun'
if (Test-Path -LiteralPath $_bunCompletions) {
  . $_bunCompletions
}

# ━━━━━━━ Carapace (optional, broad completion coverage) ━━━━━━━━━
if (Test-PwshRcTool 'carapace') {
  $env:CARAPACE_BRIDGES = 'zsh,fish,bash'
  carapace _carapace powershell | Out-String | Invoke-Expression
}
