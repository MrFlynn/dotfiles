# History settings.
export HISTFILE=$HOME/.zsh_history

HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt incappendhistory
setopt extended_history
setopt sharehistory

HIST_STAMPS="yyyy-mm-dd"

# Custom completions FPATH
# fpath=(/usr/local/share/zsh/functions $fpath)
# fpath+=~/.zfunc
# _comp_options="${_comp_options/NO_warnnestedvar/}"

# --- Path & Variables ----

# SSH key path
export SSH_KEY_PATH="$HOME/.ssh/"

# Add Miniconda to path.
export PATH=$HOME/.miniconda3/bin:$PATH

# HSTR configuration.
export HSTR_CONFIG=hicolor,prompt-bottom,blacklist #favorites-view

# GOPATH settings.
export GOPATH=$HOME/.go

# --- Keybinds ---

# Navigation
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# Ctrl-r remap for hh.
bindkey -s "\C-r" "\eqhstr\n"

# --- Aliases ---
alias getip='arp -a | awk '\''NR==1 { print $ 2}'\'''
alias docker-rm-all='docker rm $(docker ps -a -q)'
alias mcversions="curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[].id'"
alias reload="export precmd_functions=(); source $HOME/.zshrc"
alias ntmux="tmux new-session"
alias ls="ls -G"

# --- Functions ---

fileconvert () {
  # Inputs
  local input_extension="$1"
  local output_type="$2"

  if [[ $# -ne 2 ]]; then
    echo "Help: fileconvert input_extension output_extension"
  else
    $(command -v find) $PWD -iname "*.$input_extension" -exec sips -s format "$output_type" --out "{}.$output_type" {} \;
  fi
}

serial () {
  local port="$1"

  if [[ $# -ne 1 ]]; then
    echo "Help: serial port_name"
  else
    $(command -v screen) "$port" 9600,cs8,-ixon,-ixoff -L
  fi
}

alert () {
  local text="$1"
  
  if [[ $# -ne 1 ]]; then
    echo "Help: alert alert_text"
  else
    $(command -v osascript) -e "display notification \"$text\"" with title \"$(tty)\"""
  fi
}

eval "$(starship init zsh)"
