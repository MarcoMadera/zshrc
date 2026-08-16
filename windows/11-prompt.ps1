# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prompt
#
# Port of 11-prompt.zsh. zsh builds the prompt from %F/%K escapes that the
# shell expands at render time; PowerShell's `prompt` function has to emit raw
# ANSI itself, so every %F{#hex} becomes a 24-bit SGR sequence.
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ──────────── Glyphs ────────────
# Every Nerd Font glyph is built from its codepoint rather than pasted in as a
# literal. Characters in the BMP Private Use Area (U+E000-U+F8FF) — which is
# where the Powerline caps and most language icons live — do not survive every
# editor, transport and encoding round-trip, and when one is silently dropped
# the prompt still "works": you just get a coloured rectangle with no cap, or a
# version number with no icon. Codepoints keep this file pure ASCII.
$global:GLYPH = @{
  PillLeft  = [char]0xE0B6                        #  left half-circle
  PillRight = [char]0xE0B4                        #  right half-circle
  Clock     = [char]::ConvertFromUtf32(0xF0954)   # 󰥔 nf-md-clock
  Home      = [char]0xF46D                        #  nf-oct-home
  Pellet    = [char]::ConvertFromUtf32(0xF02A0)   # 󰊠 nf-md-circle
  PacOpen   = [char]::ConvertFromUtf32(0xF0BAF)   # 󰮯 nf-md-pac_man
  PacClosed = [char]0x25CF                        # ● filled circle
  Bullet    = [char]0x2022                        # •
  Timer     = [char]::ConvertFromUtf32(0xF051B)   # 󰔛 nf-md-timer
  Python    = [char]0xE73C                        #  nf-dev-python
  Node      = [char]0xED0D                        #  nf-md-nodejs
  Java      = [char]0xE738                        #  nf-dev-java
  Go        = [char]0xE627                        #  nf-seti-go
  Rust      = [char]0xE7A8                        #  nf-dev-rust
}

$global:PROMPT_CONFIG = @{
  primary_color            = 'FF8906'
  prompt_char              = " $($global:GLYPH.PacOpen)$($global:GLYPH.Bullet)"
  dot_char                 = $global:GLYPH.Pellet
  pill_separator           = " $($global:GLYPH.Bullet) "
  clock_icon               = $global:GLYPH.Clock
  # Padded on BOTH sides, matching the zsh value, so the icon sits centred
  # between the pill caps rather than flush against the left one.
  home_icon                = " $($global:GLYPH.Home) "
  enable_time_pill         = $true
  enable_mode_pill         = $true
  enable_dir_pill          = $true
  enable_git_pill          = $true
  enable_git_state_pill    = $true
  enable_git_metrics_pill  = $true
  enable_python_pill       = $true
  enable_node_pill         = $true
  enable_java_pill         = $true
  enable_go_pill           = $true
  enable_rust_pill         = $true
  enable_duration_pill     = $true
  duration_threshold       = 3
}

# ──────────── Palette Engine ────────────

$global:CURRENT_PALETTE = 'mocha'   # ← change only this  (mocha | frappe | latte)

$global:PALETTES = @{

  # ── Catppuccin Mocha (dark) ──
  'mocha.primary_fg'      = 'fab387'   # Peach
  'mocha.time_bg'         = '313244'   # Surface0
  'mocha.time_fg'         = 'cdd6f4'   # Text
  'mocha.dir_bg'          = 'b4befe'   # Lavender
  'mocha.dir_fg'          = '1e1e2e'   # Base
  'mocha.git_clean_bg'    = 'a6e3a1'   # Green
  'mocha.git_clean_fg'    = '1e1e2e'   # Base
  'mocha.git_dirty_bg'    = 'f38ba8'   # Red
  'mocha.git_dirty_fg'    = '1e1e2e'   # Base
  'mocha.mode_insert_bg'  = '89b4fa'   # Blue
  'mocha.mode_insert_fg'  = '1e1e2e'   # Base
  'mocha.mode_normal_bg'  = 'f9e2af'   # Yellow
  'mocha.mode_normal_fg'  = '1e1e2e'   # Base
  'mocha.mode_visual_bg'  = 'cba6f7'   # Mauve
  'mocha.mode_visual_fg'  = '1e1e2e'   # Base
  'mocha.mode_visbk_bg'   = 'f5c2e7'   # Pink
  'mocha.mode_visbk_fg'   = '1e1e2e'   # Base
  'mocha.python_bg'       = '89dceb'   # Sky
  'mocha.python_fg'       = '1e1e2e'   # Base
  'mocha.node_bg'         = 'f2cdcd'   # Flamingo
  'mocha.node_fg'         = '1e1e2e'   # Base
  'mocha.java_bg'         = 'eba0ac'   # Maroon
  'mocha.java_fg'         = '1e1e2e'   # Base
  'mocha.go_bg'           = '74c7ec'   # Sapphire
  'mocha.go_fg'           = '1e1e2e'   # Base
  'mocha.rust_bg'         = 'fab387'   # Peach
  'mocha.rust_fg'         = '1e1e2e'   # Base
  'mocha.git_state_bg'    = 'f9e2af'   # Yellow
  'mocha.git_state_fg'    = '1e1e2e'   # Base
  'mocha.git_metrics_bg'  = '313244'   # Surface0
  'mocha.git_metrics_fg'  = 'cdd6f4'   # Text
  'mocha.duration_bg'     = '45475a'   # Surface1
  'mocha.duration_fg'     = 'cdd6f4'   # Text

  # ── Catppuccin Frappé (medium) ──
  'frappe.primary_fg'     = 'ef9f76'
  'frappe.time_bg'        = '414559'
  'frappe.time_fg'        = 'c6d0f5'
  'frappe.dir_bg'         = '81c8be'
  'frappe.dir_fg'         = '303446'
  'frappe.git_clean_bg'   = 'a6d189'
  'frappe.git_clean_fg'   = '303446'
  'frappe.git_dirty_bg'   = 'e78284'
  'frappe.git_dirty_fg'   = '303446'
  'frappe.mode_insert_bg' = '8caaee'
  'frappe.mode_insert_fg' = '303446'
  'frappe.mode_normal_bg' = 'e5c890'
  'frappe.mode_normal_fg' = '303446'
  'frappe.mode_visual_bg' = 'ca9ee6'
  'frappe.mode_visual_fg' = '303446'
  'frappe.mode_visbk_bg'  = 'f4b8e4'
  'frappe.mode_visbk_fg'  = '303446'
  'frappe.python_bg'      = '99d1db'
  'frappe.python_fg'      = '303446'
  'frappe.node_bg'        = 'f2d5cf'
  'frappe.node_fg'        = '303446'
  'frappe.java_bg'        = 'ea999c'
  'frappe.java_fg'        = '303446'
  'frappe.go_bg'          = '85c1dc'
  'frappe.go_fg'          = '303446'
  'frappe.rust_bg'        = 'ef9f76'
  'frappe.rust_fg'        = '303446'
  'frappe.git_state_bg'   = 'e5c890'
  'frappe.git_state_fg'   = '303446'
  'frappe.git_metrics_bg' = '414559'
  'frappe.git_metrics_fg' = 'c6d0f5'
  'frappe.duration_bg'    = '51576d'
  'frappe.duration_fg'    = 'c6d0f5'

  # ── Catppuccin Latte (light) ──
  'latte.primary_fg'      = 'fe640b'
  'latte.time_bg'         = 'ccd0da'
  'latte.time_fg'         = '4c4f69'
  'latte.dir_bg'          = '179299'
  'latte.dir_fg'          = 'eff1f5'
  'latte.git_clean_bg'    = '40a02b'
  'latte.git_clean_fg'    = 'eff1f5'
  'latte.git_dirty_bg'    = 'd20f39'
  'latte.git_dirty_fg'    = 'eff1f5'
  'latte.mode_insert_bg'  = '1e66f5'
  'latte.mode_insert_fg'  = 'eff1f5'
  'latte.mode_normal_bg'  = 'df8e1d'
  'latte.mode_normal_fg'  = 'eff1f5'
  'latte.mode_visual_bg'  = '8839ef'
  'latte.mode_visual_fg'  = 'eff1f5'
  'latte.mode_visbk_bg'   = 'ea76cb'
  'latte.mode_visbk_fg'   = 'eff1f5'
  'latte.python_bg'       = '04a5e5'
  'latte.python_fg'       = 'eff1f5'
  'latte.node_bg'         = 'dc8a78'
  'latte.node_fg'         = 'eff1f5'
  'latte.java_bg'         = 'e64553'
  'latte.java_fg'         = 'eff1f5'
  'latte.go_bg'           = '209fb5'
  'latte.go_fg'           = 'eff1f5'
  'latte.rust_bg'         = 'fe640b'
  'latte.rust_fg'         = 'eff1f5'
  'latte.git_state_bg'    = 'df8e1d'
  'latte.git_state_fg'    = 'eff1f5'
  'latte.git_metrics_bg'  = 'ccd0da'
  'latte.git_metrics_fg'  = '4c4f69'
  'latte.duration_bg'     = 'e6e9ef'
  'latte.duration_fg'     = '5c5f77'
}

function global:palette {
  param([string]$Key)
  $global:PALETTES["$($global:CURRENT_PALETTE).$Key"]
}

# ──────────── ANSI Helpers ────────────

$global:PWSHRC_ESC   = [char]27
$global:PWSHRC_RESET = "$([char]27)[0m"

# Powerline half-circles, from the glyph table above
$global:PWSHRC_PILL_L = $global:GLYPH.PillLeft
$global:PWSHRC_PILL_R = $global:GLYPH.PillRight

# Building an SGR string costs a few string ops; the prompt asks for the same
# dozen colours every render, so memoise them.
$global:PWSHRC_SGR_CACHE = @{}

function global:Get-PwshRcSgr {
  param([string]$Hex, [switch]$Background)

  $key = "$Hex$($Background.IsPresent)"
  if ($global:PWSHRC_SGR_CACHE.ContainsKey($key)) { return $global:PWSHRC_SGR_CACHE[$key] }

  $h = $Hex.TrimStart('#')
  if ($h.Length -ne 6) { return '' }

  $r = [Convert]::ToInt32($h.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($h.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($h.Substring(4, 2), 16)
  $layer = if ($Background) { 48 } else { 38 }

  $sgr = "$($global:PWSHRC_ESC)[$layer;2;$r;$g;${b}m"
  $global:PWSHRC_SGR_CACHE[$key] = $sgr
  return $sgr
}

# create_pill — a rounded block of colour with the half-circle caps drawn in
# the fill colour so they blend into the terminal background.
function global:New-PwshRcPill {
  param([string]$Content, [string]$Bg, [string]$Fg)

  if (-not $Bg -or -not $Fg) { return '' }

  $fgOfBg = Get-PwshRcSgr $Bg
  $bgFill = Get-PwshRcSgr $Bg -Background
  $fgText = Get-PwshRcSgr $Fg

  "$fgOfBg$($global:PWSHRC_PILL_L)$bgFill$fgText$Content$($global:PWSHRC_RESET)$fgOfBg$($global:PWSHRC_PILL_R)$($global:PWSHRC_RESET)"
}

# ──────────── Utilities ────────────

# Port of _find_up. Returns $true as soon as any of $Names is found in $PWD or
# an ancestor. Bails out on non-filesystem providers (Cert:, HKLM: …).
function global:Find-PwshRcUp {
  param([string[]]$Names)

  if ($PWD.Provider.Name -ne 'FileSystem') { return $false }

  $dir = $PWD.ProviderPath
  while ($dir) {
    foreach ($n in $Names) {
      if (Test-Path -LiteralPath (Join-Path $dir $n)) { return $true }
    }
    $parent = Split-Path -Parent $dir
    if (-not $parent -or $parent -eq $dir) { break }
    $dir = $parent
  }
  return $false
}

# Port of _has_ext — does the current directory hold any *.ext file?
function global:Test-PwshRcHasExt {
  param([string]$Extension)

  if ($PWD.Provider.Name -ne 'FileSystem') { return $false }

  $null -ne (Get-ChildItem -LiteralPath $PWD.ProviderPath -Filter "*.$Extension" `
               -File -Force -ErrorAction SilentlyContinue | Select-Object -First 1)
}

# ──────────── Caches ────────────

$global:PWSHRC_CACHE = @{
  NodeVer = ''; NodePath = ''
  JavaVer = ''; JavaPath = ''
  PyVer   = ''; PyPath   = ''
  GoVer   = ''; GoPath   = ''
  RustVer = ''; RustPath = ''

  # Directory detection is far more expensive on Windows than on Linux, so it
  # is redone only when the working directory actually changes. Version strings
  # still refresh whenever the resolved executable moves, which is what makes
  # `nvm use` / `changeJava` show up immediately.
  DetectDir  = $null
  Detected   = @{}

  GitDir     = ''
  GitBranch  = ''
  GitDirty   = $false
  GitMetrics = ''
  GitIndexMtime = ''
  GitHead    = ''
  GitCheckedDir = $null

  LastHistoryId = -1
}

# Resolving a command that does *not* exist is the expensive case on Windows
# (~120ms per miss via Get-Command), and a project with a package.json but no
# node installed would pay it on every render. Get-PwshRcTool from 00-env.ps1
# answers from the PATH index instead, and rebuilds itself when PATH changes.
function script:Get-CmdPath {
  param([string]$Name)
  return (Get-PwshRcTool $Name)
}

# Windows ships zero-byte App Execution Alias stubs for python/python3 that
# print "…was not found; run without arguments to install from the Microsoft
# Store…" to stdout and exit 0. Without this guard that whole sentence ends up
# rendered as the version string inside a pill.
function script:Get-CleanVersion {
  param([string]$Raw)

  if (-not $Raw) { return '' }
  $v = ($Raw -split "`n")[0].Trim()

  # A version is digits and dots (plus optional pre-release suffix) — nothing else
  if ($v -match '^\d+(\.\d+)*([-+][\w.]+)?$') { return $v }
  return ''
}

function global:Update-PwshRcEnvCache {
  $c = $global:PWSHRC_CACHE

  # Re-run the file probes only on a directory change
  if ($c.DetectDir -ne $PWD.Path) {
    $c.DetectDir = $PWD.Path
    $c.Detected = @{
      Node   = (Find-PwshRcUp @('package.json', '.nvmrc'))
      Java   = (Find-PwshRcUp @('pom.xml', 'build.gradle', 'build.gradle.kts'))
      Python = ((Find-PwshRcUp @('.python-version', 'Pipfile', 'pyproject.toml',
                                 'requirements.txt', 'setup.py', 'tox.ini')) -or
                (Test-PwshRcHasExt 'py') -or (Test-PwshRcHasExt 'ipynb'))
      Go     = ((Find-PwshRcUp @('go.mod', 'go.sum', 'go.work', 'glide.yaml',
                                 'Gopkg.yml', 'Gopkg.lock', '.go-version')) -or
                (Test-PwshRcHasExt 'go'))
      Rust   = ((Find-PwshRcUp @('Cargo.toml', 'Cargo.lock')) -or (Test-PwshRcHasExt 'rs'))
    }
  }

  # ── Node ──
  if ($c.Detected.Node) {
    $p = Get-CmdPath 'node'
    if ($p -ne $c.NodePath) {
      $c.NodePath = $p
      $c.NodeVer = if ($p) { Get-CleanVersion ((& node --version 2>$null) -replace '^v', '') } else { '' }
    }
  } else { $c.NodeVer = ''; $c.NodePath = '' }

  # ── Java ──
  if ($c.Detected.Java) {
    $p = Get-CmdPath 'java'
    if ($p -ne $c.JavaPath) {
      $c.JavaPath = $p
      if ($p) {
        $raw = (& java -version 2>&1 | Select-Object -First 1)
        if ($raw -match 'version "([^"]+)"') {
          $v = $Matches[1]
          # 1.8.0_xxx → 8, otherwise take the major
          $c.JavaVer = if ($v -like '1.*') { ($v -split '\.')[1] } else { ($v -split '\.')[0] }
        } else { $c.JavaVer = '' }
      } else { $c.JavaVer = '' }
    }
  } else { $c.JavaVer = ''; $c.JavaPath = '' }

  # ── Python ──
  if ($c.Detected.Python -or $env:VIRTUAL_ENV -or
      ($env:CONDA_DEFAULT_ENV -and $env:CONDA_DEFAULT_ENV -ne 'base')) {
    $exe = (Get-CmdPath 'python') ?? (Get-CmdPath 'python3')
    $fingerprint = "$($env:VIRTUAL_ENV):$($env:CONDA_DEFAULT_ENV):$exe"
    if ($fingerprint -ne $c.PyPath) {
      $c.PyPath = $fingerprint
      if ($exe) {
        $c.PyVer = Get-CleanVersion ((& $exe --version 2>&1) -replace '^Python\s+', '')
      } else { $c.PyVer = '' }
    }
  } else { $c.PyVer = ''; $c.PyPath = '' }

  # ── Go ──
  if ($c.Detected.Go) {
    $p = Get-CmdPath 'go'
    if ($p -ne $c.GoPath) {
      $c.GoPath = $p
      $c.GoVer = if ($p) { Get-CleanVersion ((& go env GOVERSION 2>$null) -replace '^go', '') } else { '' }
    }
  } else { $c.GoVer = ''; $c.GoPath = '' }

  # ── Rust ──
  if ($c.Detected.Rust) {
    $p = Get-CmdPath 'rustc'
    if ($p -ne $c.RustPath) {
      $c.RustPath = $p
      if ($p) {
        $v = (& rustc --version 2>$null) -replace '^rustc\s+', ''
        $c.RustVer = Get-CleanVersion (($v -split ' ')[0])
      } else { $c.RustVer = '' }
    }
  } else { $c.RustVer = ''; $c.RustPath = '' }
}

# ──────────── Git ────────────

# Locate the .git directory by walking up in-process. The zsh version shells
# out to `git rev-parse` on every prompt; on Windows a process spawn is ~20ms,
# so this walk keeps the common case free of subprocesses entirely.
function global:Get-PwshRcGitDir {
  if ($PWD.Provider.Name -ne 'FileSystem') { return '' }

  $dir = $PWD.ProviderPath
  while ($dir) {
    $candidate = Join-Path $dir '.git'
    if (Test-Path -LiteralPath $candidate -PathType Container) { return $candidate }
    if (Test-Path -LiteralPath $candidate -PathType Leaf) {
      # Worktree / submodule: the file holds `gitdir: <path>`
      $content = (Get-Content -LiteralPath $candidate -Raw -ErrorAction SilentlyContinue)
      if ($content -match 'gitdir:\s*(.+)') {
        $target = $Matches[1].Trim()
        if (-not [System.IO.Path]::IsPathRooted($target)) {
          $target = Join-Path $dir $target
        }
        return [System.IO.Path]::GetFullPath($target)
      }
    }
    $parent = Split-Path -Parent $dir
    if (-not $parent -or $parent -eq $dir) { break }
    $dir = $parent
  }
  return ''
}

function global:Update-PwshRcGitCache {
  $c = $global:PWSHRC_CACHE

  if ($c.GitCheckedDir -ne $PWD.Path) {
    $c.GitCheckedDir = $PWD.Path
    $c.GitDir = Get-PwshRcGitDir
  }

  if (-not $c.GitDir) {
    $c.GitBranch = ''; $c.GitDirty = $false; $c.GitMetrics = ''
    $c.GitIndexMtime = ''; $c.GitHead = ''
    return
  }

  # vcs_info equivalent — read HEAD directly instead of spawning git
  $headFile = Join-Path $c.GitDir 'HEAD'
  $head = ''
  if (Test-Path -LiteralPath $headFile) {
    $head = (Get-Content -LiteralPath $headFile -Raw -ErrorAction SilentlyContinue)
    if ($head) { $head = $head.Trim() }
  }

  $c.GitBranch = if ($head -match '^ref:\s*refs/heads/(.+)$') {
    $Matches[1]
  } elseif ($head) {
    $head.Substring(0, [Math]::Min(7, $head.Length))   # detached HEAD
  } else { '' }

  # Cache invalidation mirrors the zsh version: index mtime + HEAD contents
  $indexFile = Join-Path $c.GitDir 'index'
  $mtime = ''
  if (Test-Path -LiteralPath $indexFile) {
    $mtime = [System.IO.File]::GetLastWriteTimeUtc($indexFile).Ticks.ToString()
  }

  if ($mtime -eq $c.GitIndexMtime -and $head -eq $c.GitHead) { return }

  $c.GitIndexMtime = $mtime
  $c.GitHead = $head

  # Only now do we pay for real git calls
  $porcelain = (& git status --porcelain 2>$null)
  $c.GitDirty = [bool]$porcelain

  # git status refreshes the index, changing its mtime — re-read so the next
  # prompt does not think it is stale again.
  if (Test-Path -LiteralPath $indexFile) {
    $c.GitIndexMtime = [System.IO.File]::GetLastWriteTimeUtc($indexFile).Ticks.ToString()
  }

  # A clean worktree cannot differ from HEAD, so the second git spawn — ~60ms
  # on Windows — is pure waste there. Only pay it when something is dirty.
  if ($global:PROMPT_CONFIG.enable_git_metrics_pill -and $c.GitDirty) {
    $shortstat = (& git diff --shortstat --no-ext-diff --ignore-submodules HEAD 2>$null) -join ' '
    $added = 0; $deleted = 0
    if ($shortstat -match '(\d+) insertion') { $added = [int]$Matches[1] }
    if ($shortstat -match '(\d+) deletion')  { $deleted = [int]$Matches[1] }
    $c.GitMetrics = if ($added -eq 0 -and $deleted -eq 0) { '' } else { "${added}:${deleted}" }
  } else {
    $c.GitMetrics = ''
  }
}

# ──────────── Pill Builders ────────────

function global:Build-TimePill {
  if (-not $global:PROMPT_CONFIG.enable_time_pill) { return '' }

  $e = $global:PWSHRC_ESC
  $content = "$($global:PROMPT_CONFIG.clock_icon) $e[1m$(Get-Date -Format 'HH:mm')$e[22m"
  New-PwshRcPill $content (palette 'time_bg') (palette 'time_fg')
}

function global:Build-ModePill {
  if (-not $global:PROMPT_CONFIG.enable_mode_pill) { return '' }
  if ($global:PWSHRC_CONFIG.EditMode -ne 'Vi') { return '' }

  switch ($global:PWSHRC_MODE) {
    'NORMAL' { New-PwshRcPill 'n' (palette 'mode_normal_bg') (palette 'mode_normal_fg') }
    'VISUAL' { New-PwshRcPill 'v' (palette 'mode_visual_bg') (palette 'mode_visual_fg') }
    'VIS-BK' { New-PwshRcPill 'b' (palette 'mode_visbk_bg')  (palette 'mode_visbk_fg') }
    default  { New-PwshRcPill 'i' (palette 'mode_insert_bg') (palette 'mode_insert_fg') }
  }
}

function global:Build-DirPill {
  if (-not $global:PROMPT_CONFIG.enable_dir_pill) { return '' }

  $p = $PWD.Path
  if ($env:HOME -and $p.StartsWith($env:HOME, [StringComparison]::OrdinalIgnoreCase)) {
    $p = $global:PROMPT_CONFIG.home_icon + $p.Substring($env:HOME.Length)
  }

  New-PwshRcPill $p (palette 'dir_bg') (palette 'dir_fg')
}

function global:Build-GitPill {
  if (-not $global:PROMPT_CONFIG.enable_git_pill) { return '' }

  $c = $global:PWSHRC_CACHE
  if (-not $c.GitBranch) { return '' }

  if ($c.GitDirty) {
    New-PwshRcPill $c.GitBranch (palette 'git_dirty_bg') (palette 'git_dirty_fg')
  } else {
    New-PwshRcPill $c.GitBranch (palette 'git_clean_bg') (palette 'git_clean_fg')
  }
}

function global:Build-GitStatePill {
  if (-not $global:PROMPT_CONFIG.enable_git_state_pill) { return '' }

  $c = $global:PWSHRC_CACHE
  if (-not $c.GitBranch -or -not $c.GitDir) { return '' }

  $g = $c.GitDir
  $state = ''; $progress = ''

  if (Test-Path -LiteralPath (Join-Path $g 'rebase-merge') -PathType Container) {
    $state = 'REBASING'
    $cur = Get-Content -LiteralPath (Join-Path $g 'rebase-merge\msgnum') -Raw -ErrorAction SilentlyContinue
    $tot = Get-Content -LiteralPath (Join-Path $g 'rebase-merge\end')    -Raw -ErrorAction SilentlyContinue
    if ($cur -and $tot) { $progress = "$($cur.Trim())/$($tot.Trim())" }
  }
  elseif (Test-Path -LiteralPath (Join-Path $g 'rebase-apply') -PathType Container) {
    $state = if (Test-Path -LiteralPath (Join-Path $g 'rebase-apply\rebasing')) { 'REBASING' }
             elseif (Test-Path -LiteralPath (Join-Path $g 'rebase-apply\applying')) { 'AM' }
             else { 'AM/REBASE' }
    $cur = Get-Content -LiteralPath (Join-Path $g 'rebase-apply\next') -Raw -ErrorAction SilentlyContinue
    $tot = Get-Content -LiteralPath (Join-Path $g 'rebase-apply\last') -Raw -ErrorAction SilentlyContinue
    if ($cur -and $tot) { $progress = "$($cur.Trim())/$($tot.Trim())" }
  }
  elseif (Test-Path -LiteralPath (Join-Path $g 'MERGE_HEAD'))        { $state = 'MERGING' }
  elseif (Test-Path -LiteralPath (Join-Path $g 'CHERRY_PICK_HEAD'))  { $state = 'CHERRY-PICKING' }
  elseif (Test-Path -LiteralPath (Join-Path $g 'REVERT_HEAD'))       { $state = 'REVERTING' }
  elseif (Test-Path -LiteralPath (Join-Path $g 'BISECT_LOG'))        { $state = 'BISECTING' }

  if (-not $state) { return '' }

  $content = if ($progress) { "$state $progress" } else { $state }
  New-PwshRcPill $content (palette 'git_state_bg') (palette 'git_state_fg')
}

function global:Build-GitMetricsPill {
  if (-not $global:PROMPT_CONFIG.enable_git_metrics_pill) { return '' }

  $m = $global:PWSHRC_CACHE.GitMetrics
  if (-not $m) { return '' }

  $added   = [int]($m -split ':')[0]
  $deleted = [int]($m -split ':')[1]

  $fg    = palette 'git_metrics_fg'
  $green = palette 'git_clean_bg'
  $red   = palette 'git_dirty_bg'

  $content = ''
  if ($added -gt 0)   { $content += "$(Get-PwshRcSgr $green)+$added$(Get-PwshRcSgr $fg)" }
  if ($deleted -gt 0) {
    if ($content) { $content += ' ' }
    $content += "$(Get-PwshRcSgr $red)-$deleted$(Get-PwshRcSgr $fg)"
  }

  New-PwshRcPill $content (palette 'git_metrics_bg') $fg
}

function global:Build-PythonPill {
  if (-not $global:PROMPT_CONFIG.enable_python_pill) { return '' }

  $v = $global:PWSHRC_CACHE.PyVer
  if (-not $v) { return '' }

  $icon = "$(Get-PwshRcSgr 'FFD43B')$($global:GLYPH.Python)$(Get-PwshRcSgr 'D0E8F7')"
  $content = "$icon $v"

  $envName = if ($env:VIRTUAL_ENV) { Split-Path -Leaf $env:VIRTUAL_ENV }
             elseif ($env:CONDA_DEFAULT_ENV -and $env:CONDA_DEFAULT_ENV -ne 'base') { $env:CONDA_DEFAULT_ENV }
             else { '' }
  if ($envName) { $content += " ($envName)" }

  New-PwshRcPill $content '1E3D5C' 'D0E8F7'
}

function global:Build-NodePill {
  if (-not $global:PROMPT_CONFIG.enable_node_pill) { return '' }
  $v = $global:PWSHRC_CACHE.NodeVer
  if (-not $v) { return '' }

  $icon = "$(Get-PwshRcSgr '6CC24A')$($global:GLYPH.Node)$(Get-PwshRcSgr 'C8E8C8')"
  New-PwshRcPill "$icon $v" '1A3D1A' 'C8E8C8'
}

function global:Build-JavaPill {
  if (-not $global:PROMPT_CONFIG.enable_java_pill) { return '' }
  $v = $global:PWSHRC_CACHE.JavaVer
  if (-not $v) { return '' }

  $icon = "$(Get-PwshRcSgr 'ED8B00')$($global:GLYPH.Java)$(Get-PwshRcSgr 'D0E8F7')"
  New-PwshRcPill "$icon $v" '1E3A5F' 'D0E8F7'
}

function global:Build-GoPill {
  if (-not $global:PROMPT_CONFIG.enable_go_pill) { return '' }
  $v = $global:PWSHRC_CACHE.GoVer
  if (-not $v) { return '' }

  $icon = "$(Get-PwshRcSgr '8FD2F9')$($global:GLYPH.Go)$(Get-PwshRcSgr 'D0E8F7')"
  New-PwshRcPill "$icon $v" '30677E' 'D0E8F7'
}

function global:Build-RustPill {
  if (-not $global:PROMPT_CONFIG.enable_rust_pill) { return '' }
  $v = $global:PWSHRC_CACHE.RustVer
  if (-not $v) { return '' }

  $icon = "$(Get-PwshRcSgr 'CE422B')$($global:GLYPH.Rust)$(Get-PwshRcSgr 'F0C5BF')"
  New-PwshRcPill "$icon $v" '2B1412' 'F0C5BF'
}

function global:Build-DurationPill {
  param([int]$Elapsed)

  if (-not $global:PROMPT_CONFIG.enable_duration_pill) { return '' }
  if ($Elapsed -lt $global:PROMPT_CONFIG.duration_threshold) { return '' }

  $label = if ($Elapsed -ge 3600) {
    "$([math]::Floor($Elapsed / 3600))h $([math]::Floor(($Elapsed % 3600) / 60))m"
  } elseif ($Elapsed -ge 60) {
    "$([math]::Floor($Elapsed / 60))m $($Elapsed % 60)s"
  } else {
    "${Elapsed}s"
  }

  New-PwshRcPill "$($global:GLYPH.Timer) $label" (palette 'duration_bg') (palette 'duration_fg')
}

# ──────────── Pac-Man ────────────
#
# LIMITATION vs. zsh: the zsh version drives the chomp from a background
# process writing into a fifo that `zle -F` polls, so the mouth animates while
# the prompt sits idle. PSReadLine exposes no timer/idle callback, so there is
# nowhere to hang that loop. Here the mouth advances one frame per prompt
# render and the pellet uses the terminal's own blink attribute, which keeps
# the "last command failed" signal without a redraw loop.

$global:PAC_OPEN    = " $($global:GLYPH.PacOpen)"
$global:PAC_CLOSED  = " $($global:GLYPH.PacClosed)"
$global:PAC_CURRENT = $global:PAC_OPEN

function global:Build-PromptChar {
  param([bool]$Success)

  $pacmanYellow = 'f9e2af'
  $pellet = $global:PROMPT_CONFIG.dot_char
  $e = $global:PWSHRC_ESC
  $reset = $global:PWSHRC_RESET

  if ($Success) {
    $global:PAC_CURRENT = $global:PAC_OPEN
    "$(Get-PwshRcSgr $pacmanYellow)$($global:PAC_OPEN)$reset $(Get-PwshRcSgr 'a6e3a1')$pellet$reset "
  } else {
    # Advance the chomp one frame per render
    $global:PAC_CURRENT = if ($global:PAC_CURRENT -eq $global:PAC_OPEN) { $global:PAC_CLOSED } else { $global:PAC_OPEN }
    "$(Get-PwshRcSgr $pacmanYellow)$($global:PAC_CURRENT)$reset $(Get-PwshRcSgr 'f38ba8')$e[5m$pellet$e[25m$reset "
  }
}

# ──────────── The Prompt ────────────

function global:prompt {
  # Must be the very first statement: any command below clobbers $?
  $success = $?

  $c = $global:PWSHRC_CACHE

  # Duration — Get-History replaces the preexec/EPOCHSECONDS timer. Only count
  # a command once, so re-renders (vi mode changes) do not repeat the pill.
  $elapsed = 0
  $last = Get-History -Count 1 -ErrorAction SilentlyContinue
  if ($last -and $last.Id -ne $c.LastHistoryId) {
    $c.LastHistoryId = $last.Id
    $elapsed = [int]($last.EndExecutionTime - $last.StartExecutionTime).TotalSeconds
  }

  # A failing native command leaves $? true but sets $LASTEXITCODE
  if ($success -and $global:LASTEXITCODE) { $success = $false }

  Update-PwshRcEnvCache
  Update-PwshRcGitCache
  Set-PwshRcWindowTitle

  $pills = @(
    Build-TimePill
    Build-ModePill
    Build-DirPill
    Build-GitPill
    Build-GitStatePill
    Build-GitMetricsPill
    Build-PythonPill
    Build-NodePill
    Build-JavaPill
    Build-GoPill
    Build-RustPill
    (Build-DurationPill $elapsed)
  ) | Where-Object { $_ }

  $topLine = $pills -join $global:PROMPT_CONFIG.pill_separator
  $promptChar = Build-PromptChar $success

  if ($env:SSH_CONNECTION) {
    $topLine = "$(Get-PwshRcSgr 'f38ba8')[SSH]$($global:PWSHRC_RESET) $topLine"
  }

  # Reset $LASTEXITCODE so the next prompt does not inherit this one's failure
  $global:LASTEXITCODE = 0

  "$topLine`n$promptChar"
}

# The prompt occupies two lines; PSReadLine needs to know so it can redraw and
# position the cursor correctly.
Set-PSReadLineOption -ExtraPromptLineCount 1
Set-PSReadLineOption -ContinuationPrompt '  ∙ '
