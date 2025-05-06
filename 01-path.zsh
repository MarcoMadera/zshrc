typeset -U path

# add paths here for any system
local_paths=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "/opt/homebrew/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)

for p in "${local_paths[@]}"; do
  [[ -d "$p" ]] && path=("$p" $path)
done

export PATH
