#!/usr/bin/env bash

# Move in script.
# Nick Pleatsikas, 2017.

# Move all dotfiles
find . -type f -iname '*.' -exec mv -t ~ {} +

# Check if last command ran correctly. Everything depends on this...
if [[ $? -ne 0 ]]; then
	echo "Move failed. Exiting..."
	exit 1
fi

# Move zsh theme
if [[ -d ~/.oh-my-zsh/themes ]]; then
	mv .oh-my-zsh/themes/dracula.zsh-theme ~/.oh-my-zsh/themes/
fi

# Check if the colors dir exists before moving the theme to it.
if [[ ! -d ~/.vim/colors ]]; then
	mkdir -p ~/.vim/colors
fi

# Install vundle packages
vim +PluginInstal +qall

# If last command ran correctly, then move theme from Vundle download.
if [[ $? -e 0 ]]; then
	mv ~/.vim/bundle/vim/colors/dracula.vim ~/.vim/colors/
else
	echo "Vundle installation failed... Using backup."
	mv .vim/colors/dracula.vim ~/.vim/colors/
fi

# Check if .ssh dir exists before moving configuration files to it.
if [[ ! -d ~/.ssh/ ]]; then
	mkdir ~/.ssh
fi
