# ━━━━━━━ PATH ━━━━━━━━━
# Mirrors `typeset -U path` + the prepend loop: only existing dirs are added,
# duplicates are collapsed, and earlier entries in the list win.

$local_paths = @(
  (Join-Path $env:HOME '.local\bin')
  (Join-Path $env:HOME '.npm-global\bin')
  (Join-Path $env:HOME 'go\bin')
  (Join-Path $env:HOME '.cargo\bin')
  (Join-Path $env:HOME '.bun\bin')
  (Join-Path $env:HOME '.opencode\bin')
  (Join-Path $env:HOME 'scoop\shims')
  (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps')
  'C:\Program Files\Git\usr\bin'      # tar, gzip, ssh, less … from Git for Windows
  'C:\Program Files\Go\bin'
)

$sep = [System.IO.Path]::PathSeparator
$existing = $env:PATH -split $sep | Where-Object { $_ }

# Prepend in reverse so the first entry of $local_paths ends up leftmost.
$prefix = @()
foreach ($p in $local_paths) {
  if ((Test-Path -LiteralPath $p -PathType Container) -and $prefix -notcontains $p) {
    $prefix += $p
  }
}

$seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$final = [System.Collections.Generic.List[string]]::new()
foreach ($p in ($prefix + $existing)) {
  $t = $p.TrimEnd('\')
  if ($t -and $seen.Add($t)) { $final.Add($p) }
}

$env:PATH = $final -join $sep

# ━━━━━━━ Node version managers ━━━━━━━━━
# fnm is the practical nvm equivalent on Windows and is the only one that can
# hook the shell; nvm-windows just swaps a symlink and needs nothing here.
$_fnm = Get-PwshRcTool 'fnm'
if ($_fnm) {
  $_init = Get-PwshRcCachedInit 'fnm' $_fnm { fnm env --use-on-cd --shell power-shell }
  if ($_init) { . $_init }
}

# ━━━━━━━ PATH-dependent environment ━━━━━━━━━
# These live here rather than in 00-env.ps1 because they resolve tools, and
# resolution is only meaningful once PATH above is final.

foreach ($_e in 'nvim', 'code', 'notepad') {
  if (Test-PwshRcTool $_e) { $env:EDITOR = $_e; break }
}
$env:VISUAL = $env:EDITOR

# bat's default pager is `less`, which Git for Windows ships but bare Windows
# does not. Fall back to bat's built-in paging rather than a broken pipe.
$env:BAT_PAGER = if (Test-PwshRcTool 'less') { 'less' } else { '' }
