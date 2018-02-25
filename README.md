# .dotfiles
These are the dotfile I use (for the most part) on personal Linux and Unix systems. 

## Prerequisites:
### MacOS:
Install [homebrew](https://brew.sh), zsh, [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), 
and git before you get started.

### Linux:
Using whatever package manager install zsh, [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), 
and git.


Finally, you will need to change your default shell to zsh:
`$ chsh -s $(which zsh)`

## Installation:
From the terminal, run these commands:
```bash
$ git clone https://github.com/MrFlynn/dotfiles.git --depth 1
$ cd dotfiles/
$ ./install.sh
```

If you are using MacOS with iTerm2, the onedark color scheme is located in the `mac_os` folder.

## Bundled Code Licenses:
`onedark.vim` and `One Dark.itermcolors`: Copyright (c) 2015 Joshua Dick under the MIT License.
Original code can be found within this [Github repo](https://github.com/joshdick/onedark.vim).
