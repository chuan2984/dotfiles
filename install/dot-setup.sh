#!/bin/bash

mkdir ~/github
gh repo clone chuan2984/dotfiles ~
gh repo clone chuan2984/alfred-backup ~/github/

cd ~/dotfiles
stow --adopt . # creates the symlink for everything in the folder and ignore existing

# download powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

