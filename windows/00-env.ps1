# ━━━━━━━ XDG Base Dirs (Windows) ━━━━━━━━━
# Windows has no $HOME by default; everything downstream assumes it.
if (-not $env:HOME) { $env:HOME = $env:USERPROFILE }

if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path $env:HOME '.config' }
if (-not $env:XDG_CACHE_HOME)  { $env:XDG_CACHE_HOME  = Join-Path $env:HOME '.cache' }
if (-not $env:XDG_DATA_HOME)   { $env:XDG_DATA_HOME   = Join-Path $env:HOME '.local\share' }
if (-not $env:XDG_STATE_HOME)  { $env:XDG_STATE_HOME  = Join-Path $env:HOME '.local\state' }

# Ensure the folders exist
foreach ($_d in @($env:XDG_CONFIG_HOME, $env:XDG_CACHE_HOME, $env:XDG_DATA_HOME,
                  $env:XDG_STATE_HOME, (Join-Path $env:XDG_CACHE_HOME 'pwsh'))) {
  if (-not (Test-Path -LiteralPath $_d)) {
    New-Item -ItemType Directory -Path $_d -Force | Out-Null
  }
}

# ━━━━━━━ Config Toggles ━━━━━━━━━
# The zsh side hardcodes `bindkey -v`; here it is a switch so emacs editing is
# one edit away instead of a rewrite.
$global:PWSHRC_CONFIG = @{
  EditMode          = 'Vi'    # Vi | Emacs
  EnableSurround    = $true   # ds/cs/ys key handlers (Vi command mode only)
  EnableModePill    = $true
  EnableTerminalIcons = $true
  EnableMsvcEnv     = $true   # cl.exe/INCLUDE/LIB on PATH (~80ms); see 09-integrations.ps1
}

$env:LANG = 'en_US.UTF-8'

# ━━━━━━━ Fast Tool Detection ━━━━━━━━━
# `Get-Command <tool>` costs ~120ms when the tool is NOT installed, because
# PowerShell walks every PATH entry against every PATHEXT extension before
# giving up. This config probes a dozen optional tools, so that alone was
# ~1.5s of startup. Indexing PATH once (~60ms, the OS filters by extension)
# makes every subsequent lookup a hashtable hit.
#
# This is the same trade the zsh side makes by caching .zcompdump.

$global:PWSHRC_TOOL_INDEX = $null
$global:PWSHRC_TOOL_INDEX_PATH = $null

function global:Build-PwshRcToolIndex {
  $idx = @{}   # PowerShell hashtables are case-insensitive, like Windows paths
  foreach ($d in ($env:PATH -split [System.IO.Path]::PathSeparator)) {
    if (-not $d) { continue }
    foreach ($pattern in '*.exe', '*.cmd', '*.bat', '*.com') {
      try {
        foreach ($f in [System.IO.Directory]::EnumerateFiles($d, $pattern)) {
          $stem = [System.IO.Path]::GetFileNameWithoutExtension($f)
          # First match wins, mirroring PATH precedence
          if (-not $idx.ContainsKey($stem)) { $idx[$stem] = $f }
        }
      } catch {
        # Unreadable or nonexistent PATH entry — skip it
      }
    }
  }
  $global:PWSHRC_TOOL_INDEX = $idx
  $global:PWSHRC_TOOL_INDEX_PATH = $env:PATH
}

# Returns the full path to an external tool, or $null. Rebuilds the index if
# PATH changed since it was built (fnm/conda/venv activation all do that).
function global:Get-PwshRcTool {
  param([string]$Name)

  if ($null -eq $global:PWSHRC_TOOL_INDEX -or $global:PWSHRC_TOOL_INDEX_PATH -ne $env:PATH) {
    Build-PwshRcToolIndex
  }
  return $global:PWSHRC_TOOL_INDEX[$Name]
}

function global:Test-PwshRcTool {
  param([string]$Name)
  return [bool](Get-PwshRcTool $Name)
}

# ━━━━━━━ Cached Shell Init ━━━━━━━━━
# Tools like zoxide and fnm print a chunk of PowerShell for the shell to eval.
# Spawning them costs ~50-80ms each at every launch, so the generated script is
# cached on disk and dot-sourced instead. The cache filename embeds the binary's
# write time, so upgrading the tool regenerates it automatically.
#
# -PathSensitive additionally keys the cache on the current $env:PATH. Some
# tools (fnm) bake a whole PATH snapshot into what they print. Keyed on the
# binary alone, such a cache goes stale the moment anything else edits PATH —
# installing a portable winget package, for instance, appends
# %LOCALAPPDATA%\Microsoft\WinGet\Links — and since the binary has not changed,
# it stays stale forever and the new tool is invisible in every shell.
function global:Get-PwshRcCachedInit {
  param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$ExePath,
    [Parameter(Mandatory)][scriptblock]$Generate,
    [switch]$PathSensitive
  )

  $cacheDir = Join-Path $env:XDG_CACHE_HOME 'pwsh\init'
  if (-not (Test-Path -LiteralPath $cacheDir)) {
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
  }

  try { $stamp = [System.IO.File]::GetLastWriteTimeUtc($ExePath).Ticks }
  catch { $stamp = 0 }

  $key = "$stamp"
  if ($PathSensitive) {
    # A content hash, not a security boundary. String.GetHashCode() is
    # deliberately avoided: .NET randomises it per process, so it would miss
    # the cache on every launch.
    $md5 = [System.Security.Cryptography.MD5]::Create()
    try {
      $bytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes([string]$env:PATH))
      $key = "$stamp.$(-join ($bytes[0..3] | ForEach-Object { $_.ToString('x2') }))"
    } finally {
      $md5.Dispose()
    }
  }

  $cacheFile = Join-Path $cacheDir "$Name.$key.ps1"
  if (Test-Path -LiteralPath $cacheFile) { return $cacheFile }

  # Binary changed (or first run) — drop older generations for this tool
  Get-ChildItem -LiteralPath $cacheDir -Filter "$Name.*.ps1" -ErrorAction SilentlyContinue |
    Remove-Item -Force -ErrorAction SilentlyContinue

  try {
    $script = & $Generate | Out-String
    if (-not $script.Trim()) { return $null }
    Set-Content -LiteralPath $cacheFile -Value $script -Encoding utf8
    return $cacheFile
  } catch {
    Write-Verbose "Could not generate init for ${Name}: $($_.Exception.Message)"
    return $null
  }
}

# ━━━━━━━ App-specific Paths ━━━━━━━━━
$env:BUN_INSTALL = Join-Path $env:HOME '.bun'

# nvm-windows exports NVM_HOME/NVM_SYMLINK; keep NVM_DIR pointing somewhere
# sane so 01-path.ps1 can probe it uniformly.
if (-not $env:NVM_DIR) { $env:NVM_DIR = Join-Path $env:XDG_CONFIG_HOME 'nvm' }

# ━━━━━━━ Repo location ━━━━━━━━━
# PWSHRC_DIR is normally set by the $PROFILE loader that bootstrap.ps1 writes.
# Fall back to this file's own directory when a module is dot-sourced directly.
if (-not $global:PWSHRC_DIR) {
  $global:PWSHRC_DIR = Split-Path -Parent $PSCommandPath
}
