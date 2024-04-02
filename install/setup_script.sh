#!/bin/bash

# Create a directory to store the files
mkdir temp_brew_install
cd temp_brew_install

# Use curl to download the files from GitHub
curl -LO https://raw.githubusercontent.com/chuan2984/dotfiles/main/install/brew.sh
curl -LO https://raw.githubusercontent.com/chuan2984/dotfiles/main/install/Brewfile

# Run the first script
./brew.sh

if [ $? -eq 0 ]; then
  cd ..
  rm -rf temp_brew_install
  rm setup_script.sh
fi

