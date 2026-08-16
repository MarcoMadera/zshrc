# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Aliases
#
# PowerShell aliases cannot take arguments, and its resolution order puts
# aliases *ahead* of functions — so every alias below that shadows a builtin
# (gc, gcm, gp, gl, cls, ls …) has to have the builtin removed first.
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function script:Remove-BuiltinAlias {
  param([string[]]$Names)
  foreach ($n in $Names) {
    if (Test-Path -LiteralPath "Alias:\$n") {
      Remove-Item -LiteralPath "Alias:\$n" -Force -ErrorAction SilentlyContinue
    }
  }
}

Remove-BuiltinAlias @(
  'gc', 'gcm', 'gp', 'gl', 'gcb', 'gm',   # Get-Content/Command/ItemProperty/Location/Clipboard/Member
  'ls', 'cls', 'h', 'r', 'l'
)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Basic Git Operations
function global:ga     { git add @args }
function global:gs     { git status @args }
function global:gc     { git commit @args }
function global:gcm    { git commit -m @args }
function global:gcam   { git commit -am @args }
function global:gp     { git push @args }
function global:gpl    { git pull @args }
function global:gf     { git fetch @args }

# Branching and Navigation
function global:gco    { git checkout @args }
function global:gb     { git branch @args }

# Viewing Changes
function global:gd     { git diff @args }
function global:gl     { git log --oneline @args }
function global:glg    { git log --stat --max-count=10 @args }
function global:glog   { git log --graph --decorate --pretty=oneline --abbrev-commit --all @args }
function global:lol    { git log --oneline --graph --decorate @args }

# Advanced Operations
function global:gr     { git rebase @args }
function global:grs    { git reset @args }
function global:gundo  { git reset --soft HEAD~1 }
function global:gamend { git commit --amend --no-edit }

# Stash Management
function global:gst    { git stash @args }
function global:gstp   { git stash pop @args }
function global:gstl   { git stash list @args }
function global:gsta   { git stash apply @args }
function global:gstd   { git stash drop @args }

# Git Helpers
function global:galias { Get-Command -CommandType Function | Where-Object { $_.Definition -match '\bgit\b' } | Select-Object Name, Definition }

# ━━━━━━━ Bitwarden ━━━━━━━━━
function global:bwunlock {
  $p = Join-Path $env:XDG_CACHE_HOME 'bw_session'
  bw unlock --raw | Set-Content -LiteralPath $p -NoNewline
}
function global:bwsession {
  $p = Join-Path $env:XDG_CACHE_HOME 'bw_session'
  if (Test-Path -LiteralPath $p) { $env:BW_SESSION = (Get-Content -LiteralPath $p -Raw).Trim() }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Navigation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:..    { Set-Location .. }
function global:...   { Set-Location ../.. }
function global:....  { Set-Location ../../.. }
function global:back  { Set-Location - }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File Listing
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if (Test-PwshRcTool 'eza') {
  function global:ls { eza --icons @args }
  function global:l  { eza -lbF --git @args }
  function global:ll { eza -laBF --git @args }
  function global:lt { eza -lbF --git --tree --level=3 @args }
} else {
  # Terminal-Icons gives Get-ChildItem the icon column eza would have provided
  function global:ls { Get-ChildItem @args }
  function global:l  { Get-ChildItem @args | Format-Table -AutoSize }
  function global:ll { Get-ChildItem -Force @args | Format-Table -AutoSize }
  function global:lt { Get-ChildItem -Recurse -Depth 2 @args }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System & Network
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# clear + wipe scrollback, the way `clear && printf '\e[3J'` does
function global:cls {
  [Console]::Write("$([char]27)[H$([char]27)[2J$([char]27)[3J")
}

function global:h { Get-History @args }

# ss -tulanp
function global:ports {
  Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, State,
      @{ n = 'Process'; e = { (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName } } |
    Sort-Object LocalPort
}

function global:myip {
  try { (Invoke-RestMethod -Uri 'https://ipinfo.io/ip' -TimeoutSec 5).Trim() }
  catch { Write-Warning "Could not reach ipinfo.io: $($_.Exception.Message)" }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:pwshrc { & ($env:EDITOR ?? 'notepad') $global:PWSHRC_DIR }
Set-Alias -Name zshrc -Value pwshrc -Scope Global -Force

# Windows has no exec(), so `reload` starts a fresh shell and exits when it
# returns. Behaviourally the same as `exec zsh`; it just stacks a process.
function global:reload {
  $pwshPath = (Get-Process -Id $PID).Path
  & $pwshPath -NoLogo
  exit
}

# Cheaper alternative when you only changed a module and want it re-read
function global:reload-profile { . $PROFILE.CurrentUserAllHosts }

# ━━━━━━━ Utils ━━━━━━━━━
function global:reminders    { Get-Job }
function global:killreminder { Get-Job | Stop-Job -PassThru | Remove-Job }

# ━━━━━━━ Zoxide ━━━━━━━━━
# --cmd cd makes zoxide replace `cd` outright, which is what `alias cd='z'` does
# on the zsh side (and it handles removing the builtin alias itself).
$_zoxide = Get-PwshRcTool 'zoxide'
if ($_zoxide) {
  $_init = Get-PwshRcCachedInit 'zoxide' $_zoxide { zoxide init powershell --cmd cd }
  if ($_init) { . $_init }
}
