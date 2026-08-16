# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   UI Tweaks & Visual Enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# The zsh side reapplies a quickshell/Hyprland-generated palette before every
# prompt. That machinery is Linux-only; on Windows the terminal owns its own
# colour scheme, so this file only sets what PowerShell itself controls.

# ━━━━━━━ Error rendering ━━━━━━━━━
# The default multi-line "ConciseView with squiggles" is noisy next to a
# two-line prompt.
$ErrorView = 'ConciseView'

if ($PSStyle) {
  $PSStyle.Formatting.Error        = $PSStyle.Foreground.FromRgb(0xf3, 0x8b, 0xa8)  # Mocha Red
  $PSStyle.Formatting.Warning      = $PSStyle.Foreground.FromRgb(0xf9, 0xe2, 0xaf)  # Mocha Yellow
  $PSStyle.Formatting.Verbose      = $PSStyle.Foreground.FromRgb(0x89, 0xb4, 0xfa)  # Mocha Blue
  $PSStyle.Formatting.Debug        = $PSStyle.Foreground.FromRgb(0xcb, 0xa6, 0xf7)  # Mocha Mauve
  $PSStyle.Formatting.ErrorAccent  = $PSStyle.Foreground.FromRgb(0xfa, 0xb3, 0x87)  # Mocha Peach
  $PSStyle.Progress.View           = 'Minimal'
}

# ━━━━━━━ Window title ━━━━━━━━━
# Keeps the tab readable when several shells are open on different repos.
function global:Set-PwshRcWindowTitle {
  $leaf = Split-Path -Leaf $PWD.Path
  if (-not $leaf) { $leaf = $PWD.Path }
  $Host.UI.RawUI.WindowTitle = $leaf
}
