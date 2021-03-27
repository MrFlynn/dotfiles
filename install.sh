#!/usr/bin/env bash

set -ou pipefail

# Install required packages.
if [[ "$(uname -s)" == Linux ]]; then
    DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ "$DISTRO" == "Ubuntu" ]]; then
        apt-get install -y zsh fzf ripgrep git
    else
        >&2 echo "OS not supported!"
        exit 1
    fi
elif [[ "$(uname -s)" == Darwin ]]; then
    # Install homebrew
    if ! command -v brew &> /dev/null
    then
        /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew install zsh fzf ripgrep git
else
    >&2 echo "OS not supported!"
    exit 1
fi

# Change default shell to zsh.
chsh -s "$(command -v zsh)"

# Move all dotfiles.
find . -type f -iname ".*" -not -name ".gitignore" -exec mv -t ~ {} +

# Install vim-plug.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim packages.
vim +PlugInstall

# Configure git.
git config --global user.email "nick@pleatsikas.me"
git config --global user.name "MrFlynn"
git config --global core.editor vim

genssh() {
    ssh-keygen -t ed25519 -f ~/.ssh/github

    if [[ "$(uname -s)" == Linux ]]; then
        cat >> ~/.ssh/config <<EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
EOF
    elif [[ "$(uname -s)" == Darwin ]]; then
        cat >> ~/.ssh/config <<EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
    AddKeysToAgent yes
    UseKeychain yes
EOF
    fi
}

# (Optional) Create ssh key.
while read -r option; do
    case $option in
        yes | y)
            genssh
            exit            
            ;;
        no | n)
            exit
            ;;
        *)
            >&2 echo "Unknown option"
            ;;
    esac
done

