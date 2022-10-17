#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen node-js npm tmux starship stow
git clone https://github.com/neovim/neovim ~/repositories/neovim
cd ~/repositories/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

git clone https://github.com/davepotts/dotfiles.git ~/.dotfiles

stow nvim
stow zsx
stow tmux
stow starship
stow bash

nvim -c PackerSync
#clone .dotfiles
#stow dotfiles
#run :PackerSync
#davepotts1981@gmail.com 
