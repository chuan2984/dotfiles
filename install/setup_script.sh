#!/bin/bash

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already installed — nothing to do."
  exit 0
fi

# -p makes it safe even if it already exists
mkdir -p temp_brew_install
cd temp_brew_install

# Use curl to download the files from GitHub
curl -LO https://raw.githubusercontent.com/chuan2984/dotfiles/main/install/brew.sh
curl -LO https://raw.githubusercontent.com/chuan2984/dotfiles/main/install/Brewfile

chmod +x brew.sh
./brew.sh

# Check if Homebrew was actually installed
if command -v brew >/dev/null 2>&1; then
  cd ..
  rm -rf temp_brew_install
  rm -f setup_script.sh
  echo "Homebrew installed successfully — cleaned up."
else
  cd ..
  echo "Homebrew installation not detected — leaving temp_brew_install for debugging."
fi
