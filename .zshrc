### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
   zdharma-continuum/zinit-annex-as-monitor \
   zdharma-continuum/zinit-annex-bin-gem-node \
   zdharma-continuum/zinit-annex-patch-dl \
   zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# User customizations
zinit light zsh-users/zsh-autosuggestions
zinit light sindresorhus/pure

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
