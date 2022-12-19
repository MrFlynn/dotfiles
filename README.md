# .dotfiles
These are the dotfile I use (for the most part) on personal Unix systems. 

## Installation
You'll need to install several dependencies before you can use these dotfiles.

- zsh
- [nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)

Once you've installed these dependencies, you can then run the following
commands. Once these have finished running (it'll take some time), your
environment is now set up.

```bash
$ cp -r {.zshrc,.vimrc,.tmux.conf,.nixpkgs/} ~
$ darwin-rebuild switch
```

## License
This repository is licensed under the [MIT](/LICENSE) license.
