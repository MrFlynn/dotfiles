#!/usr/bin/env bash

# Move in script.
# Nick Pleatsikas, 2017.

# Move all dotfiles.
find . -type f -iname "*." -exec mv -t ~ {} +

# Check if last command ran correctly. Everything depends on this...
if [[ $? -ne 0 ]]; then
	echo "Move failed. Exiting..."
	exit 1
fi

# Clone newest copy of Dracula theme to ZSH.
git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/themes/ --depth 1 

# If the last command failed to run and the dir exits, move the backup.
if [[ $? -ne 0 ]] &&  [[ -d ~/.oh-my-zsh-themes ]]; then
	mv .oh-my-zsh/themes/dracula.zsh-theme ~/.oh-my-zsh/themes/
fi

# Install Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1

# If last command failed, then prompt but continue running.
if [[ $? -ne 0 ]]; then
	echo "Vundle install failed."
fi

# Check if the colors dir exists before moving the theme to it.
if [[ ! -d ~/.vim/colors ]]; then
	mkdir -p ~/.vim/colors
fi

# Install vundle packages
vim +PluginInstall +qall

# If last command ran correctly, then move theme from Vundle download.
if [[ $? -e 0 ]]; then
	mv ~/.vim/bundle/onedark.vim/colors/onedark.vim ~/.vim/colors/
else
	echo "Vundle installation failed... Using backup."
	mv .vim/colors/onedark.vim ~/.vim/colors/
fi

# Check if .ssh dir exists before moving configuration files to it.
if [[ ! -d ~/.ssh/ ]]; then
	mkdir ~/.ssh
fi

# Configure git.
git config --global user.email "nick@pleatsikas.me"
git config --global user.name "MrFlynn"
git config --global core.editor vim
