# `.dotfiles`
This repository contains the base environment I use across all of my development
systems (for personal and work purposes). It encompases dotfiles, packages, and
environment configurations.

I use [home-manager](https://nix-community.github.io/home-manager) to manage my
environment. However, some of the configurations (e.g. for `tmux`) I retain
separate configurations for (and have home-manager manage on systems with nix)
so that I can easily copy them to other systems if I don't want to (or can't) go
through the process of installing nix on to them.

## Installation
You will need to install [nix](https://nixos.org/) to use these dotfiles. I
recommend using
[Determinate Systems' Nix distribution](https://determinate.systems/posts/determinate-nix-installer/):

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

### Initial Setup
Clone the repository and switch to the home-manager configuration (this installs
home-manager on first run):

```bash
git clone git@github.com:MrFlynn/dotfiles.git ~/.config/home-manager
cd ~/.config/home-manager
nix run github:nix-community/home-manager -- switch --flake ".#nick-$(nix eval --raw --impure --expr 'builtins.currentSystem')"
```

### Subsequent Updates
After the initial setup, you can use the home-manager command directly:

```bash
home-manager switch --flake ".#nick-$(nix eval --raw --impure --expr 'builtins.currentSystem')"
```

The flake automatically detects your system architecture and applies the
appropriate configuration.

## License
This repository is licensed under the [MIT](/LICENSE) license.
