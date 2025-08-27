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
You will need to install both [nix](https://nixos.org/) and
[home-manager](https://nix-community.github.io/home-manager/index.xhtml#ch-installation)
to install these dotfiles. For the nix portion I personally use Determinate
System's Nix distribution, so the commands I use to set up both of those
dependencies are as follows:

```bash
$ curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
$ nix-channel --add https://nixos.org/channels/nixos-unstable
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

Next, to install the dotfiles/packages/etc. use the following commands:

```bash
$ mkdir -p ~/.config/home-manager
$ rm -f ~/.config/home-manager/*
$ git clone git@github.com:MrFlynn/dotfiles.git ~/.config/home-manager
$ home-manager switch
```

## License
This repository is licensed under the [MIT](/LICENSE) license.
