#!/usr/bin/env bash

# Move in script for WSL platforms.
# Nick Pleatsikas, 2017.

# Fix hostname.
sudo sed -i "2i 127.0.0.1 $(/bin/hostname)" /etc/hosts

# Move all dotfiles.
find . -type f -iname "*." -exec mv -t ~ {} +

# Check if last command ran correctly. Everything depends on this...
if [[ $? -ne 0 ]]; then
	echo "Move failed. Exiting..."
	exit 1
fi

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1

# If last command failed, then prompt but continue running.
if [[ $? -ne 0 ]]; then
	echo "Vundle install failed."
fi

# Install vundle packages
vim +PluginInstall +qall

# Check if .ssh dir exists before moving configuration files to it.
if [[ ! -d ~/.ssh/ ]]; then
	mkdir ~/.ssh
fi

# Configure git.
git config --global user.email "nick@pleatsikas.me"
git config --global user.name "MrFlynn"
git config --global core.editor vim

# Launch zsh by default:
sed -i '/# for examples/ a if [ -t 1 ]; then \
	exec zsh \
fi' ~/.bashrc
