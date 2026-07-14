#!/bin/bash
set -e  # exit immediately if any command fails

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found — installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed — skipping install."
fi

echo "Adding homebrew to PATH..."
if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
  echo >> "$HOME/.zprofile"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
else
  echo "PATH entry already present in .zprofile — skipping."
fi
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

echo "Installing homebrew packages..."

echo "Unlinking any existing vim..."
brew unlink vim || true   # don't fail if vim wasn't linked

echo "Installing macvim..."
brew install macvim

echo "Linking macvim..."
brew link macvim

echo "Installing stow..."
brew install stow

brewfile="$(pwd)/Brewfile"
if [ ! -f "$brewfile" ]; then
  echo "Error: Brewfile not found at $brewfile"
  exit 1
fi

echo "Running brew bundle with $brewfile..."
brew bundle --file "$brewfile"

echo "Homebrew setup complete."
exit 0
