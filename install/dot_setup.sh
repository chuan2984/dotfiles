#!/bin/bash

mkdir ~/github
git clone https://github.com/chuan2984/dotfiles ~/dotfiles
git clone https://github.com/chuan2984/alfred-backup ~/github/alfred-backup
git clone https://github.com/chuan2984/obsidian ~/github/obsidian

cd ~/dotfiles
stow --adopt . # creates the symlink for everything in the folder and ignore existing

# download powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# loads yabai on startup
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
