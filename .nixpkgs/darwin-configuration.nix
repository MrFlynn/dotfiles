{ config, pkgs, ... }:
let
  dontCheckPackage = drv: drv.overridePythonAttrs (old: { doCheck = false; });
  customized-python = pkgs.python311.withPackages(p: with p; [
    (dontCheckPackage httpie)
    (dontCheckPackage pipx)
  ]);
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
    vim 
    htop
    fzf
    ripgrep
    tmux
    unstable.go
    jq
    customized-python
    pipenv
    shellcheck
    moreutils
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Manage homebrew
  homebrew.enable = true;
  homebrew.brews = [
    "trash"
  ];
  homebrew.casks = [
    "multipass"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
