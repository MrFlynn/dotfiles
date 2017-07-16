## .dotfiles

These are the dotfile I use (for the most part) on Bash for Windows (WSL; Windows 
Subsystem for Linux). 

### Installation:
#### Install Dependencies:
Install ZSH, [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), and git before running the install script:
```bash
$ sudo apt-get update
$ sudo apt-get install zsh git
```
(At the time of writing this, Ubuntu was the only option).

#### Let's install:
From the terminal, run these commands:
```bash
$ git clone https://github.com/MrFlynn/dotfiles.git --depth 1
$ cd dotfiles/
$ ./install.sh
```
