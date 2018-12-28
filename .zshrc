# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme.
ZSH_THEME="dracula"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Oh-my-zsh plugins.
plugins=(git brew osx pip tmux docker vagrant)

source $ZSH/oh-my-zsh.sh

# Custom completions FPATH
fpath=(/usr/local/share/zsh-completions $fpath)
fpath+=~/.zfunc

# --- Path & Variables ----

# SSH key path
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Add Miniconda to path.
export PATH=$HOME/Documents/miniconda3/bin:$PATH

# HSTR history file.
export HISTFILE=~/.zsh_history

# GOPATH settings.
export GOPATH=$HOME/.go

# --- Aliases ---
alias getip='arp -a | awk '\''NR==1 { print $ 2}'\'''
alias docker-rm-all='docker rm $(docker ps -a -q)'
alias mcversions="curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .versions | jq -r '.[].id'"
alias reload="source $HOME/.zshrc"
alias ntmux="tmux new-session"

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
    $(command -v screen) "$port" 9600,cs8,-ixon,-ixoff
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
