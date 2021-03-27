# Adding zinit
if [[ ! -f $HOME/.zinit/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit" && \\
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \\
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# User-defined plugins
zinit light zsh-users/zsh-autosuggestions
zinit light sendresorhus/pure

zinit load zdharma/history-search-multi-word

zinit snippet OMZP::git

# Shell options
setopt share_history
setopt append_history

backward-only-delete-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
    zle -N backward-only-delete-dir
}

bindkey '\C-w' backward-only-delete-dir

# Aliases
alias reload="source ~/.zshrc"
alias ls="ls -G"
