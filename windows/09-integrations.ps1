# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   External Tool Integrations (fzf, zoxide, bun, msvc)
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

# ━━━━━━━ MSVC toolchain ━━━━━━━━━
# Visual Studio ships a C compiler, but cl.exe / INCLUDE / LIB only exist inside
# a Developer prompt. Things launched from a normal shell cannot build native
# code without it — nvim-treesitter shells out to `tree-sitter build`, which
# fails with a bare "no such file or directory (cmd): cl" otherwise.
#
# Entering a dev shell costs ~2.9s, far too much to pay at every launch, so the
# environment *delta* it produces is captured once and replayed from cache,
# which brings it down to ~80ms. Only the delta is stored, and PATH is merged as
# a prefix rather than assigned wholesale — that is what lets this compose with
# fnm's PATH from 01-path.ps1 instead of clobbering it.
#
# That 80ms is still real, and only native builds need it. Set
# PWSHRC_CONFIG.EnableMsvcEnv = $false in 00-env.ps1 to skip it and call
# Import-PwshRcMsvcEnv by hand when compiling.
function global:Import-PwshRcMsvcEnv {
  if ($env:VCINSTALLDIR) { return }   # already inside a Developer prompt

  $cacheDir = Join-Path $env:XDG_CACHE_HOME 'pwsh\init'
  if (-not (Test-Path -LiteralPath $cacheDir)) {
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
  }

  # Warm path: never spawn vswhere, never parse JSON. The cache is a plain
  # script of literal assignments whose first line records the VsDevCmd.bat it
  # was built from, so freshness costs one line read plus one file stat.
  # vswhere alone is ~150ms, and ConvertFrom-Json about the same — either would
  # be paid at every launch just to learn that nothing changed.
  # .NET calls rather than Get-ChildItem/Get-Content here for the same reason
  # Build-PwshRcToolIndex uses them: cmdlet overhead dominates at this size.
  $cached = $null
  try {
    foreach ($f in [System.IO.Directory]::EnumerateFiles($cacheDir, 'msvc.*.ps1')) {
      $cached = $f
      break
    }
  } catch { }

  if ($cached) {
    $head = ''
    try {
      foreach ($line in [System.IO.File]::ReadLines($cached)) { $head = $line; break }
    } catch { }

    if ($head -match '^#\s*devcmd:\s*(.+)$') {
      $known = $Matches[1]
      if ([System.IO.File]::Exists($known)) {
        $stamp = [System.IO.File]::GetLastWriteTimeUtc($known).Ticks
        if ([System.IO.Path]::GetFileName($cached) -eq "msvc.$stamp.ps1") {
          . $cached
          return
        }
      }
    }

    # Visual Studio moved or was updated — rebuild below.
    Remove-Item -LiteralPath $cached -Force -ErrorAction SilentlyContinue
  }

  # Cold path, run once per VS install/update.
  $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
  if (-not (Test-Path -LiteralPath $vswhere)) { return }

  $vs = & $vswhere -latest -products * `
    -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    -property installationPath 2>$null
  if (-not $vs) { return }

  $devCmd = Join-Path $vs 'Common7\Tools\VsDevCmd.bat'
  if (-not (Test-Path -LiteralPath $devCmd)) { return }

  try { $stamp = [System.IO.File]::GetLastWriteTimeUtc($devCmd).Ticks }
  catch { $stamp = 0 }
  $cacheFile = Join-Path $cacheDir "msvc.$stamp.ps1"

  if (-not (Test-Path -LiteralPath $cacheFile)) {
    # VS was updated (or this is the first run) — drop older generations
    Get-ChildItem -LiteralPath $cacheDir -Filter 'msvc.*.ps1' -ErrorAction SilentlyContinue |
      Remove-Item -Force -ErrorAction SilentlyContinue

    # `cmd /c "call VsDevCmd.bat && set"` is used rather than the DevShell
    # PowerShell module: it runs in a child process, so the probe cannot
    # pollute this shell, and it is noticeably faster.
    $lines = & cmd.exe /c "`"$devCmd`" -arch=x64 -host_arch=x64 -no_logo && set" 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $lines) { return }

    $vars = @{}
    $pathPrefix = @()
    $current = @($env:PATH -split ';' | Where-Object { $_ })

    foreach ($line in $lines) {
      if ($line -notmatch '^([^=]+)=(.*)$') { continue }
      $name = $Matches[1]
      $value = $Matches[2]

      # cmd exposes pseudo-variables like "=C:" and its own PROMPT/COMSPEC
      if ($name -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') { continue }
      if ($name -in @('PROMPT', 'COMSPEC', 'PATHEXT')) { continue }

      if ($name -eq 'PATH') {
        $pathPrefix = @($value -split ';' | Where-Object { $_ -and $current -notcontains $_ })
      } elseif ((Get-Item "env:$name" -ErrorAction SilentlyContinue).Value -ne $value) {
        $vars[$name] = $value
      }
    }

    if (-not $vars.Count -and -not $pathPrefix.Count) { return }

    # Emit literal assignments. The devcmd header lets the warm path above
    # verify freshness without asking vswhere where Visual Studio lives.
    $q = { param($s) "'" + ($s -replace "'", "''") + "'" }
    $out = [System.Collections.Generic.List[string]]::new()
    $out.Add("# devcmd: $devCmd")
    $out.Add('# Generated by 09-integrations.ps1 - safe to delete, it rebuilds.')

    foreach ($name in ($vars.Keys | Sort-Object)) {
      $out.Add("`$env:$name = $(& $q $vars[$name])")
    }

    if ($pathPrefix.Count) {
      # Prepend, skipping anything already present. A HashSet keeps this O(n)
      # and case-insensitive, matching how Windows compares paths.
      $literal = ($pathPrefix | ForEach-Object { & $q $_ }) -join ', '
      $out.Add("`$__pre = @($literal)")
      $out.Add('$__cur = $env:PATH -split '';'' | Where-Object { $_ }')
      $out.Add('$__seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)')
      $out.Add('foreach ($__p in $__cur) { [void]$__seen.Add($__p.TrimEnd(''\'')) }')
      $out.Add('$__add = foreach ($__p in $__pre) { if (-not $__seen.Contains($__p.TrimEnd(''\''))) { $__p } }')
      $out.Add('if ($__add) { $env:PATH = ((@($__add) + @($__cur)) -join '';'') }')
      $out.Add('Remove-Variable __pre, __cur, __seen, __add, __p -ErrorAction SilentlyContinue')
    }

    Set-Content -LiteralPath $cacheFile -Value $out -Encoding utf8
  }

  . $cacheFile
}

if ($global:PWSHRC_CONFIG.EnableMsvcEnv) { Import-PwshRcMsvcEnv }
