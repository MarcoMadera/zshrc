# ━━━━━━━ Console Setup (zmodload equivalent) ━━━━━━━━━
# The zsh side loads complist/datetime/parameter/stat. PowerShell has all of
# that built in; what it does *not* guarantee is a UTF-8 console, and every
# Nerd Font glyph in the prompt depends on it.

[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding           = [System.Text.UTF8Encoding]::new($false)

# Make native commands (git, rg, fd …) hand back UTF-8 rather than the OEM
# codepage, so accented paths and glyphs survive the pipeline.
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# ━━━━━━━ Virtual Terminal ━━━━━━━━━
# Windows Terminal enables VT by default; conhost does not. Without this the
# prompt renders as literal escape sequences.
if (-not $env:WT_SESSION) {
  try {
    $sig = @'
using System;
using System.Runtime.InteropServices;
public static class PwshRcVT {
  [DllImport("kernel32.dll", SetLastError=true)]
  public static extern IntPtr GetStdHandle(int nStdHandle);
  [DllImport("kernel32.dll", SetLastError=true)]
  public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
  [DllImport("kernel32.dll", SetLastError=true)]
  public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
  public static void Enable() {
    IntPtr h = GetStdHandle(-11);
    uint mode;
    if (GetConsoleMode(h, out mode)) { SetConsoleMode(h, mode | 0x0004); }
  }
}
'@
    if (-not ('PwshRcVT' -as [type])) { Add-Type -TypeDefinition $sig -ErrorAction Stop }
    [PwshRcVT]::Enable()
  } catch {
    Write-Verbose "Could not enable VT processing: $($_.Exception.Message)"
  }
}

# PSStyle exists in PS 7.2+; make sure it is not stripping our escapes.
if ($PSStyle) {
  $PSStyle.OutputRendering = 'Host'
}
