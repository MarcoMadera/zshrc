# My Shell Config

A modular shell config in two parallel ports:

| | Shell | Location | Bootstrap |
|---|---|---|---|
| **Linux / macOS** | zsh | `*.zsh` in the repo root | `./bootstrap.sh` |
| **Windows** | PowerShell 7+ | `windows/*.ps1` | `windows\bootstrap.ps1` |

Both halves use the same numbered-module layout, so `07-aliases.zsh` and
`windows/07-aliases.ps1` cover the same ground.

## 🐧 Setup — Linux / macOS

1. Clone it anywhere you want:

   ```sh
   git clone https://github.com/MarcoMadera/zshrc.git
   cd zshrc
   ```

2. Make the bootstrap script executable:

   ```sh
   chmod +x ./bootstrap.sh
   ```

3. Run the script:

   ```sh
   ./bootstrap.sh
   ```

## 🪟 Setup — Windows

Requires **PowerShell 7+** (`winget install Microsoft.PowerShell`) and a
Nerd Font selected in your terminal, or the prompt icons render as boxes.

1. Clone it anywhere you want:

   ```powershell
   git clone https://github.com/MarcoMadera/zshrc.git
   cd zshrc\windows
   ```

2. Run the bootstrap:

   ```powershell
   .\bootstrap.ps1
   ```

   It backs up your existing profile, writes a loader into `$PROFILE`,
   and asks before installing anything. Useful switches:

   | Switch | Effect |
   |---|---|
   | `-SkipTools` | Do not install CLI tools via winget |
   | `-SkipModules` | Do not install PSGallery modules |
   | `-RemoveOhMyPosh` | Uninstall oh-my-posh (11-prompt.ps1 replaces it) |
   | `-Force` | Answer yes to every prompt |

3. Reload:

   ```powershell
   reload
   ```

### What the Windows port maps onto

| zsh | PowerShell |
|---|---|
| zinit (+ turbo mode) | PSGallery modules; posh-git loads on the first `git <TAB>` and PSFzf on the first Tab/Ctrl-R/Ctrl-T, since together they cost ~1.3s to import eagerly |
| `compinit` + `zstyle` | PSReadLine options + `Register-ArgumentCompleter` |
| zsh-syntax-highlighting | PSReadLine's built-in tokenizer colours |
| zsh-autosuggestions | PSReadLine prediction (`HistoryAndPlugin`) |
| fzf-tab | PSFzf `-TabExpansion` |
| `bindkey -v` + zle widgets | `-EditMode Vi` + `Set-PSReadLineKeyHandler` |
| `vcs_info` / `precmd` hooks | the `prompt` function in `11-prompt.ps1` |
| `HISTFILE` in XDG cache | `-HistorySavePath` in XDG cache |
| `~/.zshrc.local` | `~/.pwshrc.local.ps1` and `$XDG_CONFIG_HOME/pwshrc.d/*.ps1` |

### Gotchas worth knowing if you edit this

- **All key bindings must live in `13-keybindings.ps1`** (or in `06-vi-mode.ps1`
  *after* the EditMode switch). `Set-PSReadLineOption -EditMode` resets the
  entire key table to that mode's defaults, so anything bound in an earlier
  module is silently discarded.
- **`Get-Command` costs ~120ms per miss** on Windows. Use `Test-PwshRcTool` /
  `Get-PwshRcTool` (from `00-env.ps1`) for external binaries — they answer from
  a PATH index built once at startup.
- **Terminal-Icons is only imported when eza is absent**, since `eza --icons`
  already covers it and the module costs ~745ms.
- **Nerd Font family names are not what you'd guess.** The JetBrainsMono Nerd
  Font ttfs register as `JetBrainsMono NFM` (Mono), `NF` and `NFP` (Propo) —
  *not* "JetBrainsMono Nerd Font Mono". Setting the wrong name in Windows
  Terminal fails silently back to the default font. Check with:
  ```powershell
  Add-Type -AssemblyName System.Drawing
  (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name -match 'NF'
  ```

### Known gaps vs. the zsh version

- **Pac-Man does not animate while idle.** The zsh version drives the chomp
  from a background process writing into a fifo that `zle -F` polls. PSReadLine
  exposes no timer or idle callback, so the mouth advances one frame per prompt
  render instead, and the failed-command pellet uses the terminal's own blink
  attribute.
- **Vi surround is normal-mode only.** `ds`, `cs` and `ys` work; the visual-mode
  text objects (`vi"`, `va(`, …) are not ported, because PSReadLine does not
  expose its visual selection state to key handlers.
- **No `VISUAL` / `VIS-BK` mode pill.** PSReadLine's `ViModeChangeHandler`
  only reports `Insert` and `Command`.
- **`reload` stacks a process.** Windows has no `exec()`, so it starts a fresh
  shell and exits when that one returns.
- The Linux-only bits — the quickshell/Hyprland palette reapply in `10-ui.zsh`
  and the Qt/Hyprland environment in `00-env.zsh` — are intentionally absent.

### Configuration

`windows/00-env.ps1` holds the toggles:

```powershell
$global:PWSHRC_CONFIG = @{
  EditMode            = 'Vi'    # Vi | Emacs
  EnableSurround      = $true
  EnableModePill      = $true
  EnableTerminalIcons = $true
}
```

Prompt pills and the colour scheme live in `windows/11-prompt.ps1` —
`$global:CURRENT_PALETTE` switches between `mocha`, `frappe` and `latte`,
and each pill has its own `enable_*_pill` flag in `$global:PROMPT_CONFIG`,
exactly as on the zsh side.
