typeset -U path

# add paths here for any system
local_paths=(
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/go/bin"
  "/opt/homebrew/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "$HOME/Qt/6.10.1/macos/bin"
  "$HOME/.opencode/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  "$HOME/.antigravity/antigravity/bin"
)

for p in "${local_paths[@]}"; do
  [[ -d "$p" ]] && path=("$p" $path)
done

export PATH
