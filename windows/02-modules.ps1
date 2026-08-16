# ━━━━━━━ Module Manager (zinit equivalent) ━━━━━━━━━
# zinit clones plugins on first use; PowerShell's equivalent is the PSGallery.
# Installing at shell startup would cost seconds, so this file only *imports*
# what is present — bootstrap.ps1 does the installing.

$global:PWSHRC_MODULES = @(
  'PSReadLine'            # zle replacement: editing, history, prediction
  'CompletionPredictor'   # IntelliSense-style completion predictions
)

# Terminal-Icons costs ~745ms to import and exists only to put icons on
# Get-ChildItem output — which is exactly what `eza --icons` already does.
# When eza is installed the aliases in 07-aliases.ps1 all route through it, so
# the module is dead weight; it is only worth loading as the eza fallback.
if (-not (Test-PwshRcTool 'eza') -and $global:PWSHRC_CONFIG.EnableTerminalIcons) {
  $global:PWSHRC_MODULES += 'Terminal-Icons'
}

# posh-git (~730ms) and PSFzf (~560ms) are loaded on first use instead — see
# the lazy blocks at the bottom of this file.
$global:PWSHRC_LAZY_MODULES = @('posh-git', 'PSFzf')

$global:PWSHRC_MISSING_MODULES = @()

# `Get-Module -ListAvailable -Name X` re-scans every PSModulePath root and costs
# ~70ms per call — 350ms across this list. Enumerating the module directories
# once answers all of them. A directory existing is not proof the module is
# importable, which is why the Import-Module below is still wrapped in try.
$global:PWSHRC_MODULE_INDEX = [System.Collections.Generic.HashSet[string]]::new(
  [System.StringComparer]::OrdinalIgnoreCase)

foreach ($root in ($env:PSModulePath -split [System.IO.Path]::PathSeparator)) {
  if (-not $root) { continue }
  try {
    foreach ($d in [System.IO.Directory]::EnumerateDirectories($root)) {
      [void]$global:PWSHRC_MODULE_INDEX.Add([System.IO.Path]::GetFileName($d))
    }
  } catch {
    # Missing or unreadable module root — skip
  }
}

foreach ($m in $global:PWSHRC_MODULES) {
  if ($global:PWSHRC_MODULE_INDEX.Contains($m)) {
    try {
      Import-Module $m -ErrorAction Stop
    } catch {
      Write-Verbose "Failed to import ${m}: $($_.Exception.Message)"
      $global:PWSHRC_MISSING_MODULES += $m
    }
  } else {
    $global:PWSHRC_MISSING_MODULES += $m
  }
}

# ━━━━━━━ Lazy: posh-git ━━━━━━━━━
# Importing posh-git costs ~730ms — a third of the whole startup — and the only
# part this config wants is `git <TAB>` completion (its prompt is redundant,
# 11-prompt.ps1 renders git state from its own cache).
#
# So we register a placeholder completer that imports posh-git on the first Tab
# after `git` and delegates to it. Import happens once, off the startup path.
# This is the same trick zinit's turbo mode plays on the zsh side.
if ($global:PWSHRC_MODULE_INDEX.Contains('posh-git')) {

  Register-ArgumentCompleter -Native -CommandName git, tgit, gitk -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    if (-not (Get-Module posh-git)) {
      Import-Module posh-git -ErrorAction SilentlyContinue

      # posh-git's own completer replaces this one on import, so every
      # subsequent Tab goes straight to it — this block runs at most once.
      if (Get-Module posh-git) {
        $GitPromptSettings.EnablePromptStatus = $false
        $GitPromptSettings.EnableFileStatus   = $false
      }
    }

    # Serve the keystroke that triggered the import
    if (Get-Command Expand-GitCommand -ErrorAction SilentlyContinue) {
      Expand-GitCommand $commandAst.ToString()
    }
  }
} else {
  $global:PWSHRC_MISSING_MODULES += 'posh-git'
}

# ━━━━━━━ Lazy: PSFzf ━━━━━━━━━
# Importing PSFzf costs ~560ms, and it also throws outright when the fzf binary
# is absent. Both problems go away by deferring it to the first Ctrl+R / Ctrl+T
# / Tab, which is also when its keybindings first matter.
#
# 04-completions.ps1 leaves Tab on PSReadLine's MenuComplete; once PSFzf loads
# it takes Tab over itself, so only the very first Tab uses the plain menu.
$global:PWSHRC_PSFZF_LOADED = $false
# Tells 04-completions.ps1 and 13-keybindings.ps1 not to rebind Tab / Ctrl+R,
# which would clobber the lazy handlers registered below.
$global:PWSHRC_PSFZF_LAZY = $false

function global:Initialize-PwshRcPSFzf {
  if ($global:PWSHRC_PSFZF_LOADED) { return $true }

  Import-Module PSFzf -ErrorAction SilentlyContinue
  if (-not (Get-Module PSFzf)) { return $false }

  # Hands Tab, and only Tab, to PSFzf from here on
  Set-PsFzfOption -TabExpansion
  $global:PWSHRC_PSFZF_LOADED = $true
  return $true
}

# The actual key bindings live in 13-keybindings.ps1, NOT here: 06-vi-mode.ps1
# calls `Set-PSReadLineOption -EditMode Vi`, and changing EditMode resets every
# key handler to that mode's defaults. Anything bound before then is silently
# discarded. This file only decides *whether* lazy PSFzf is viable.
if ($global:PWSHRC_MODULE_INDEX.Contains('PSFzf')) {
  if (Test-PwshRcTool 'fzf') {
    $global:PWSHRC_PSFZF_LAZY = $true
  } else {
    # Module present but the binary is not — importing would throw outright
    Write-Verbose 'PSFzf installed but fzf binary not on PATH; skipping.'
  }
} else {
  $global:PWSHRC_MISSING_MODULES += 'PSFzf'
}

if ($global:PWSHRC_MISSING_MODULES.Count -gt 0 -and -not $env:PWSHRC_QUIET) {
  Write-Host "  Missing modules: $($global:PWSHRC_MISSING_MODULES -join ', ') — run bootstrap.ps1" -ForegroundColor DarkYellow
}
