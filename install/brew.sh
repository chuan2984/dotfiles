#!/bin/bash
if test ! $(which brew); then
  echo "Installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

# overwrite default vim
brew unlink vim # in case a vim has already been linked
brew install macvim
brew link macvim
brew install stow

brewfile="$(pwd)/Brewfile"

brew bundle --file $brewfile

exit 0
