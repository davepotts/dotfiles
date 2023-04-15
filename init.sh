#!/bin/bash

sudo apt update && sudo apt upgrade -y

ln -svf ~/dotfiles/.config ~/.config
ln -svf ~/dotfiles/.bashrc ~/.bashrc
ln -svf ~/dotfiles/.bash_aliases ~/.bash_aliases
