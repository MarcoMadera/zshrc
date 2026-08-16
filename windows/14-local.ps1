# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Local Overrides & Machine-Specific Hooks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Anything machine-specific — work proxies, private aliases, API keys — goes
# here rather than in the tracked modules.
$_localProfile = Join-Path $env:HOME '.pwshrc.local.ps1'
if (Test-Path -LiteralPath $_localProfile) {
  . $_localProfile
}

# Drop-in directory, for when one file is not enough
$_localDir = Join-Path $env:XDG_CONFIG_HOME 'pwshrc.d'
if (Test-Path -LiteralPath $_localDir) {
  Get-ChildItem -LiteralPath $_localDir -Filter '*.ps1' -ErrorAction SilentlyContinue |
    Sort-Object Name | ForEach-Object { . $_.FullName }
}
