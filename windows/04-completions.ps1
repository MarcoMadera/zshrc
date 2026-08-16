# ━━━━━━━ Completion Core ━━━━━━━━━
# compinit has no analogue: PowerShell builds completions from cmdlet metadata
# at call time. What is configurable is how they are *presented*.

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -CompletionQueryItems 100

# Prediction needs a real VT-capable console. When output is redirected (CI, a
# piped `pwsh -Command`, a dumb host) PSReadLine throws, which would abort the
# rest of this file — so it is attempted separately and allowed to fail.
try {
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction Stop
  Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
} catch {
  Write-Verbose "Predictions unavailable in this host: $($_.Exception.Message)"
}

# ── fzf-tab equivalent ──
# PSFzf routes tab-completion through fzf with a preview pane, which is as
# close as this gets to the zstyle ':fzf-tab:*' fzf-preview block.
#
# The Tab binding for it — and the plain MenuComplete fallback — are set in
# 13-keybindings.ps1, because 06-vi-mode.ps1 resets all key handlers when it
# switches EditMode, and this file runs before that.

# ━━━━━━━ Argument Completers ━━━━━━━━━

# ── winget ──
if (Test-PwshRcTool 'winget') {
  Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $word = $wordToComplete.Replace('"', '""')
    $ast  = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$word" --commandline "$ast" --position $cursorPosition |
      ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }
  }
}

# ── dotnet ──
if (Test-PwshRcTool 'dotnet') {
  Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() |
      ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }
  }
}

# ── gh ──
if (Test-PwshRcTool 'gh') {
  Register-ArgumentCompleter -Native -CommandName gh -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $env:COMP_LINE  = $commandAst.ToString()
    $env:COMP_POINT = $cursorPosition
    gh completion -s powershell 2>$null | Out-Null
    gh __complete ($commandAst.CommandElements | Select-Object -Skip 1) 2>$null |
      Where-Object { $_ -notmatch '^:' -and $_ -like "$wordToComplete*" } |
      ForEach-Object {
        $t = ($_ -split "`t")[0]
        [System.Management.Automation.CompletionResult]::new($t, $t, 'ParameterValue', $t)
      }
    Remove-Item Env:COMP_LINE, Env:COMP_POINT -ErrorAction SilentlyContinue
  }
}

# ── Stop-Service: only offer services that are actually running ──
Register-ArgumentCompleter -CommandName Stop-Service -ParameterName Name -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.Name -like "$wordToComplete*" } |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name)
    }
}

# ── Set-TimeZone ──
Register-ArgumentCompleter -CommandName Set-TimeZone -ParameterName Id -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  (Get-TimeZone -ListAvailable).Id | Where-Object { $_ -like "$wordToComplete*" } |
    ForEach-Object { "'$_'" }
}

# ── Chocolatey (only if it is actually installed) ──
$_chocoProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if ($env:ChocolateyInstall -and (Test-Path -LiteralPath $_chocoProfile)) {
  Import-Module $_chocoProfile -ErrorAction SilentlyContinue
}
