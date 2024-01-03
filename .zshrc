# Zinit installation
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# User customiztions
zinit light-mode for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zsh-users/zsh-autosuggestions \
    sindresorhus/pure

zinit load zdharma/history-search-multi-word

# Shell options
setopt share_history
setopt append_history

# Disable annoying right hand side prompt
export RPS1=""

# Custom functions
function nix-shell-unstable () {
    nix-shell -p "(import <nixos-unstable> {}).$1"
}

function check-dotfile-repo () {
    local dotfiles_repo="$1"

    if [[ -z "$dotfiles_repo" ]]; then
        dotfiles_repo="$HOME/Documents/dotfiles"
    fi

    setopt extendedglob

    for file in $(print -rl $dotfiles_repo/.^(git|gitignore)); do
        diff --brief "$file" "$HOME/$(basename $file)"
    done

    unsetopt extendedglob
}
