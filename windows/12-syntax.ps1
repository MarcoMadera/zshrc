# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Syntax Highlighting & Autosuggestions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# zsh needs zsh-syntax-highlighting for this; PSReadLine tokenizes the buffer
# natively, so the port is a colour table rather than a plugin.

$e = [char]27
function script:Rgb { param([string]$Hex, [string]$Extra = '')
  $h = $Hex.TrimStart('#')
  $r = [Convert]::ToInt32($h.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($h.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($h.Substring(4, 2), 16)
  "$([char]27)[${Extra}38;2;$r;$g;${b}m"
}

# PSReadLine only accepts the token names it knows about; there is no
# `Function` token (zsh-syntax-highlighting's function/alias/builtin all fall
# under Command here), and an unknown key throws and aborts the whole file.
Set-PSReadLineOption -Colors @{
  # ── Autosuggestions ──
  # Catppuccin Mocha — Overlay0 for unobtrusive ghost text
  InlinePrediction        = Rgb '6c7086'
  ListPrediction          = Rgb '6c7086'
  ListPredictionTooltip   = Rgb '9399b2'          # overlay1
  ListPredictionSelected  = "$([char]27)[48;2;69;71;90m"

  # ── Syntax Highlighting — Catppuccin Mocha ──
  Command            = Rgb 'a6e3a1'               # green   (alias/function/builtin)
  Parameter          = Rgb 'cba6f7'               # mauve
  Variable           = Rgb 'f5c2e7'               # pink
  String             = Rgb 'f9e2af'               # yellow  (single+double quoted)
  Number             = Rgb 'fab387'               # peach
  Operator           = Rgb '94e2d5'               # teal    (redirection)
  Type               = Rgb '89dceb'               # sky
  Comment            = Rgb '6c7086'               # overlay0
  Keyword            = Rgb '89b4fa'               # blue    (builtin, bold in zsh)
  Member             = Rgb 'b4befe'               # lavender
  Default            = Rgb 'cdd6f4'               # text
  Error              = Rgb 'f38ba8'               # red
  Emphasis           = Rgb 'f5c2e7'               # pink    (search match)
  ContinuationPrompt = Rgb '6c7086'               # overlay0
  Selection          = "$([char]27)[48;2;69;71;90m"   # surface1 background
}
