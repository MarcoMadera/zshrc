# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Administration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# `please` — sudo. Windows 11 has a native `sudo` (Settings → For developers →
# Enable sudo); gsudo is the common third-party stand-in. Falls back to
# relaunching the command in an elevated window.
function global:please {
  if ($args.Count -eq 0) {
    $last = (Get-History -Count 1).CommandLine
    if (-not $last) { Write-Warning 'No previous command to elevate.'; return }
    $cmd = $last
  } else {
    $cmd = $args -join ' '
  }

  foreach ($s in 'sudo', 'gsudo') {
    if (Test-PwshRcTool $s) {
      & $s pwsh -NoLogo -NoProfile -Command $cmd
      return
    }
  }

  Write-Host "Elevating in a new window: $cmd" -ForegroundColor Yellow
  Start-Process -FilePath (Get-Process -Id $PID).Path -Verb RunAs `
    -ArgumentList '-NoExit', '-Command', $cmd
}

function global:whereami {
  $hostName = [System.Net.Dns]::GetHostName()
  Write-Host "🖥️  Host:      $hostName"

  try {
    $info = Invoke-RestMethod -Uri 'https://ipinfo.io/json' -TimeoutSec 5
    Write-Host "🌐 IP:        $($info.ip)"
    Write-Host "📍 Location:  $($info.city), $($info.country)"
  } catch {
    Write-Host "🌐 IP:        unavailable"
    Write-Host "📍 Location:  unknown ($($_.Exception.Message))"
  }

  Write-Host "🕰  Time:      $(Get-Date -Format 'dddd, MMMM dd — HH:mm tt')"
}

# jinfo — the zsh version inspects background jobs via ps(1)
function global:jinfo {
  $jobs = Get-Job
  if (-not $jobs) { return }

  foreach ($j in $jobs) {
    Write-Host ("=== Job {0} [{1}] ===" -f $j.Id, $j.State)
    Write-Host $j.Command
  }
}

function global:nswp-clean {
  # Swap lives under Neovim's *state* dir, which on Windows is named
  # "nvim-data" (not "nvim") and honours XDG_STATE_HOME when it is set.
  # %LOCALAPPDATA%\nvim-data is the data dir, not the state dir, so it is
  # listed last and only helps when the XDG vars are unset.
  $dir = $null
  $candidates = @(
    (Join-Path $env:XDG_STATE_HOME 'nvim-data\swap')
    (Join-Path $env:XDG_STATE_HOME 'nvim\swap')
    (Join-Path $env:LOCALAPPDATA 'nvim-data\swap')
  )
  foreach ($c in $candidates) {
    if ($c -and (Test-Path -LiteralPath $c)) { $dir = $c; break }
  }

  if ($dir) {
    Write-Host 'Cleaning Neovim swap files...'
    Get-ChildItem -LiteralPath $dir -Filter '*.swp' -File -ErrorAction SilentlyContinue |
      Remove-Item -Force
    Write-Host 'Done.'
  } else {
    Write-Host 'No swap directory found.'
  }
}

# killPort — carried over from the previous profile
function global:killPort {
  param([Parameter(Mandatory)][int]$Port)

  $conns = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
  if (-not $conns) { Write-Warning "Nothing is listening on port $Port."; return }

  # NB: $PID is a read-only automatic variable — the loop var must not be $pid
  foreach ($procId in ($conns.OwningProcess | Sort-Object -Unique)) {
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
    if ($proc) {
      Write-Host "Stopping $($proc.ProcessName) (PID $procId) on port $Port"
      Stop-Process -Id $procId -Force
    }
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Application Wrappers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# y — yazi, inheriting the directory you left it in
function global:y {
  if (-not (Test-PwshRcTool 'yazi')) {
    Write-Warning 'yazi is not installed.'; return
  }

  $tmp = [System.IO.Path]::GetTempFileName()
  try {
    yazi @args --cwd-file="$tmp"
    $cwd = (Get-Content -LiteralPath $tmp -Raw -ErrorAction SilentlyContinue)
    if ($cwd) { $cwd = $cwd.Trim() }
    if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
      Set-Location -LiteralPath $cwd
    }
  } finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
  }
}

# n — nvim
function global:n {
  if (-not (Test-PwshRcTool 'nvim')) {
    Write-Warning 'nvim is not installed.'; return
  }
  nvim @args
}

# cat — bat with paging off, matching the zsh wrapper. Get-Content is still
# reachable by its full name for anything that needs real objects.
Remove-Item -LiteralPath 'Alias:\cat' -Force -ErrorAction SilentlyContinue
function global:cat {
  if ((Test-PwshRcTool 'bat') -and $args.Count -gt 0) {
    bat --paging=never @args
  } else {
    Get-Content @args
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Directory Management
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:mkcd {
  param([Parameter(Mandatory)][string]$Path)
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
  Set-Location -LiteralPath $Path
}

function global:tmpd {
  $dir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
  Write-Host "Created temporary directory: $dir"
  Set-Location -LiteralPath $dir
}

function global:dirsize {
  param([string]$Path = '.')

  $bytes = (Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum).Sum
  if (-not $bytes) { $bytes = 0 }

  $units = 'B', 'K', 'M', 'G', 'T'
  $i = 0
  while ($bytes -ge 1024 -and $i -lt $units.Count - 1) { $bytes /= 1024; $i++ }
  # Double quotes so `t is a real tab — du -sh puts one between size and path
  "{0:N1}{1}`t{2}" -f $bytes, $units[$i], $Path
}

function global:up {
  param([int]$Count = 1)
  Set-Location (('..\' * $Count).TrimEnd('\'))
}

function global:bwstart {
  $env:BW_SESSION = (bw unlock --raw)
  if ($env:BW_SESSION) { Write-Host '🟢 Vault started.' } else { Write-Host '🔴 Start failed.' }
}

# removeEmptyFolders / Copy-ItemToAllSubdirectories / removeFolder —
# carried over from the previous profile
function global:removeEmptyFolders {
  param([Parameter(Mandatory)][string]$Path)

  # Repeat until stable so nested empties collapse too
  do {
    $empty = Get-ChildItem -LiteralPath $Path -Recurse -Directory -Force -ErrorAction SilentlyContinue |
             Where-Object { -not (Get-ChildItem -LiteralPath $_.FullName -Recurse -Force -File -ErrorAction SilentlyContinue) }
    $empty | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
  } while ($empty)
}

function global:Copy-ItemToAllSubdirectories {
  param(
    [Parameter(Mandatory)][string]$PathToFile,
    [Parameter(Mandatory)][string]$DestinationPath
  )
  Get-ChildItem -LiteralPath $DestinationPath -Recurse -Directory |
    ForEach-Object { Copy-Item -LiteralPath $PathToFile -Destination $_.FullName -Force }
}

function global:removeFolder {
  param([Parameter(Mandatory)][string]$FolderPath)
  Remove-Item -LiteralPath $FolderPath -Recurse -Force
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Search Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:findtext {
  if (Test-PwshRcTool 'rg') {
    rg --color=auto @args
  } else {
    Select-String -Path (Join-Path $PWD '*') -Pattern $args[0] -Recurse
  }
}

function global:findfile {
  if (Test-PwshRcTool 'fd') {
    fd @args
  } else {
    Get-ChildItem -Recurse -File -Filter "*$($args[0])*" -ErrorAction SilentlyContinue
  }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File Operations
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# extract — tar ships with Windows 10+; 7z/unrar are used when present
function global:extract {
  param([Parameter(Mandatory)][string]$Path)

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Warning "'$Path' is not a valid file"; return
  }

  switch -Regex ($Path) {
    '\.tar\.bz2$|\.tbz2$' { tar xjf $Path }
    '\.tar\.gz$|\.tgz$'   { tar xzf $Path }
    '\.tar\.xz$'          { tar xJf $Path }
    '\.tar$'              { tar xf  $Path }
    '\.zip$'              { Expand-Archive -LiteralPath $Path -DestinationPath . -Force }
    '\.rar$'              {
      if (Test-PwshRcTool 'unrar') { unrar e $Path }
      elseif (Test-PwshRcTool '7z') { 7z x $Path }
      else { Write-Warning 'Need unrar or 7z to extract .rar' }
    }
    '\.7z$'               {
      if (Test-PwshRcTool '7z') { 7z x $Path }
      else { Write-Warning 'Need 7z to extract .7z' }
    }
    '\.gz$'               {
      if (Test-PwshRcTool '7z') { 7z x $Path }
      else { tar xzf $Path }
    }
    default { Write-Warning "'$Path' cannot be extracted via extract()" }
  }
}

function global:targz {
  param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Source
  )
  tar -zcvf "$Name.tar.gz" $Source
}

function global:zipit {
  param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Source
  )
  Compress-Archive -Path $Source -DestinationPath "$Name.zip" -Force
}

# toZip — carried over from the previous profile
function global:toZip {
  param([Parameter(Mandatory, ValueFromPipeline)][string]$Path)

  $dest = Join-Path $env:USERPROFILE 'compressed'
  if (-not (Test-Path -LiteralPath $dest)) {
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
  }

  $name = (Split-Path $Path -Leaf).Split('.')[0]
  Compress-Archive -Path $Path -DestinationPath (Join-Path $dest "$name.zip") -Force
}

# mkexe — chmod +x has no meaning on Windows. The equivalent friction is the
# Mark-of-the-Web on downloaded files, so unblock instead.
function global:mkexe {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Warning "File '$Path' not found."; return
  }
  Unblock-File -LiteralPath $Path
  Write-Host "Unblocked '$Path' (Windows has no executable bit)."
}

function global:bak {
  param([Parameter(Mandatory)][string]$Path)
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $dest = "$Path.bak.$stamp"
  Copy-Item -LiteralPath $Path -Destination $dest -Recurse -Force
  Write-Host "Backed up $Path to $dest"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Web Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:weather {
  param([string]$Location = '')
  try {
    (Invoke-RestMethod -Uri "https://wttr.in/$Location" -TimeoutSec 10) -split "`n" | Select-Object -First 7
  } catch { Write-Warning $_.Exception.Message }
}

function global:cheat {
  param([Parameter(Mandatory)][string]$Topic)
  try { Invoke-RestMethod -Uri "https://cheat.sh/$Topic" -TimeoutSec 10 }
  catch { Write-Warning $_.Exception.Message }
}

function global:headers {
  param([Parameter(Mandatory)][string]$Url)
  try {
    $r = Invoke-WebRequest -Uri $Url -Method Head -MaximumRedirection 10 -SkipHttpErrorCheck
    "HTTP $($r.StatusCode)"
    $r.Headers.GetEnumerator() | ForEach-Object { "{0}: {1}" -f $_.Key, ($_.Value -join ', ') }
  } catch { Write-Warning $_.Exception.Message }
}

function global:serve {
  param([int]$Port = 8000)

  $ip = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
         Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
         Select-Object -First 1 -ExpandProperty IPAddress)
  if (-not $ip) { $ip = 'localhost' }

  Write-Host "Serving current directory ($PWD) at http://${ip}:${Port}"

  foreach ($py in 'python3', 'python', 'py') {
    if (Test-PwshRcTool $py) { & $py -m http.server $Port; return }
  }
  Write-Warning 'Python not found. Cannot start HTTP server.'
}

function global:qr {
  if ($args.Count -eq 0) { Write-Host 'Usage: qr <text>'; return }
  try { Invoke-RestMethod -Uri "https://qrenco.de/$($args -join ' ')" -Headers @{ 'User-Agent' = 'curl' } }
  catch { Write-Warning $_.Exception.Message }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Time Management
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:stopwatch {
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  Write-Host '⏱ Stopwatch started. Press any key to stop...'
  [Console]::ReadKey($true) | Out-Null
  $sw.Stop()
  "⏰ Elapsed: {0:N3}s" -f $sw.Elapsed.TotalSeconds
}

function global:timer {
  param([int]$Seconds = 5)

  Write-Host "⏳ Countdown: $Seconds seconds"
  while ($Seconds -gt 0) {
    Write-Host -NoNewline "`r🕒 $Seconds...   "
    Start-Sleep -Seconds 1
    $Seconds--
  }
  Write-Host "`r🔔 Time's up!         "
  [System.Media.SystemSounds]::Exclamation.Play()
}

function global:remindme {
  $msg = if ($args.Count) { $args -join ' ' } else { "Hey, time's up!" }
  try {
    Add-Type -AssemblyName System.Speech -ErrorAction Stop
    $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $s.Speak($msg)
    $s.Dispose()
  } catch {
    Write-Host $msg
  }
}

# `in` is a PowerShell keyword inside foreach(), so the function is named
# `remind` and `in` is offered as an alias for muscle memory.
function global:remind {
  param([Parameter(Mandatory)][int]$Minutes)
  $msg = if ($args.Count) { $args -join ' ' } else { 'Reminder' }

  Write-Host "⏰ I'll remind you in $Minutes minute(s): $msg"
  Start-Job -ScriptBlock {
    param($m, $t)
    Start-Sleep -Seconds ($m * 60)
    Add-Type -AssemblyName System.Speech
    $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $s.Speak($t)
  } -ArgumentList $Minutes, $msg | Out-Null
}
Set-Alias -Name in -Value remind -Scope Global -Force

function global:today { Get-Date -Format '🗓 dddd, MMMM dd, yyyy — 🕒 hh:mm tt' }

function global:saycolor {
  $colors = @(
    @{ Name = 'Midnight Blue';   Hex = '191970' }
    @{ Name = 'Crimson Red';     Hex = 'DC143C' }
    @{ Name = 'Neon Green';      Hex = '39FF14' }
    @{ Name = 'Cyber Grape';     Hex = '58427C' }
    @{ Name = 'Pastel Pink';     Hex = 'FFD1DC' }
    @{ Name = 'Royal Purple';    Hex = '7851A9' }
    @{ Name = 'Solar Flare';     Hex = 'FF5E13' }
    @{ Name = 'Deep Teal';       Hex = '014D4D' }
    @{ Name = 'Sunbeam Yellow';  Hex = 'FFF200' }
    @{ Name = 'Ghost White';     Hex = 'F8F8FF' }
  )

  $c = $colors | Get-Random
  $r = [Convert]::ToInt32($c.Hex.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($c.Hex.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($c.Hex.Substring(4, 2), 16)
  $e = [char]27

  Write-Host "🎨 Your color vibe is $e[1;38;2;$r;$g;${b}m$($c.Name)$e[0m (#$($c.Hex))"
  remindme "Your color is $($c.Name)"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Utility Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function global:pwgen {
  param([int]$Length = 16)

  $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%&*'
  $bytes = [byte[]]::new($Length)
  [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)

  -join ($bytes | ForEach-Object { $chars[$_ % $chars.Length] })
}

function global:calc {
  $expr = $args -join ' '
  # Only arithmetic gets through — no arbitrary code from a mistyped expression.
  if ($expr -notmatch '^[\d\s\.\+\-\*/%\(\)]+$') {
    Write-Warning 'calc accepts numbers and + - * / % ( ) only.'
    return
  }
  # PowerShell already promotes `7/2` to 3.5, so no bc-style scale is needed
  ([double](Invoke-Expression $expr)).ToString('0.####')
}

function global:bless {
  if ($args.Count -eq 0) { Write-Host '😇 Usage: bless <command> [args...]'; return }

  Write-Host '🙏 Blessing this command with divine energy:'
  Write-Host "🧾 → $($args -join ' ')"
  $answer = Read-Host 'Proceed? [y/N]'
  if ($answer -notmatch '^[Yy]') { Write-Host '❌ Aborted'; return }

  Write-Host "`n✨ Executing..."
  & $args[0] @($args | Select-Object -Skip 1)
  $code = $LASTEXITCODE

  if (-not $code) {
    Write-Host '🕊️  Success. The gods smile upon your work.'
  } else {
    Write-Host '💀 Something broke. Offer a sacrifice or debug it yourself.'
  }
}

function global:coinflip {
  if ((Get-Random -Maximum 2) -eq 0) {
    Write-Host '🪙 Heads – go for it.'
  } else {
    Write-Host '🪙 Tails – abort mission.'
  }
}

function global:shouldi {
  $action = if ($args.Count) { $args -join ' ' } else { 'do this' }
  $verdicts = 'Yes.', 'No.', 'Absolutely.', 'Hell no.', 'Try again later.', 'Flip a coin.'
  Write-Host "🤔 Should you $action`?"
  Write-Host "👉 $($verdicts | Get-Random)"
}

function global:breathe {
  param([int]$Cycles = 3, [int]$Inhale = 4, [int]$Hold = 7, [int]$Exhale = 8)

  Write-Host "🧘 Beginning $Cycles breathing cycles..."
  Write-Host "    Inhale: $Inhale seconds"
  Write-Host "    Hold: $Hold seconds"
  Write-Host "    Exhale: $Exhale seconds"

  for ($i = 1; $i -le $Cycles; $i++) {
    Write-Host -NoNewline "Cycle ${i}: "
    foreach ($phase in @(@('Inhale', $Inhale), @('Hold', $Hold), @('Exhale', $Exhale))) {
      Write-Host -NoNewline "$($phase[0])... "
      for ($j = $phase[1]; $j -gt 0; $j--) {
        Write-Host -NoNewline "$j "
        Start-Sleep -Seconds 1
      }
    }
    Write-Host ''
  }

  Write-Host '✨ Breathing complete. Feel centered.'
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FZF Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if (Test-PwshRcTool 'fzf') {

  # Fuzzy find a file and open it in $EDITOR
  function global:fe {
    $preview = 'bat --color=always --style=numbers --line-range=:500 {}'
    $file = if (Test-PwshRcTool 'fd') {
      fd --type f . --hidden --exclude .git | fzf --preview $preview
    } else {
      Get-ChildItem -Recurse -File -Force -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty FullName | fzf --preview $preview
    }
    if ($file) { & ($env:EDITOR ?? 'notepad') $file }
  }

  # Fuzzy find a directory and cd into it
  function global:fcd {
    $dir = if (Test-PwshRcTool 'fd') {
      fd --type d . --hidden --exclude .git | fzf
    } else {
      Get-ChildItem -Recurse -Directory -Force -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty FullName | fzf
    }
    if ($dir) { Set-Location -LiteralPath $dir }
  }

  # changeJava — the Windows analogue of /usr/libexec/java_home. Scans the
  # usual JDK install roots and repoints JAVA_HOME for this session.
  function global:changeJava {
    $roots = @(
      'C:\Program Files\Java'
      'C:\Program Files\Eclipse Adoptium'
      'C:\Program Files\Microsoft\jdk'
      'C:\Program Files\Amazon Corretto'
      (Join-Path $env:LOCALAPPDATA 'Programs\Eclipse Adoptium')
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

    $jdks = foreach ($r in $roots) {
      Get-ChildItem -LiteralPath $r -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'bin\java.exe') }
    }

    if (-not $jdks) { Write-Warning 'No JDK installations found.'; return }

    $choice = $jdks | Select-Object -ExpandProperty FullName | fzf --prompt 'JDK> '
    if (-not $choice) { return }

    $env:JAVA_HOME = $choice
    $env:PATH = (Join-Path $choice 'bin') + [System.IO.Path]::PathSeparator +
                (($env:PATH -split [System.IO.Path]::PathSeparator |
                  Where-Object { $_ -notlike '*\bin' -or $_ -notmatch 'jdk|java|adoptium|corretto' }) -join [System.IO.Path]::PathSeparator)
    java --version
  }
}
