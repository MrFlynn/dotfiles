{ config, pkgs, ... }:

let
  basePackages = with pkgs; [
    fzf
    git
    gitui
    gnused
    htop
    ijq
    jless
    jq
    kubectl
    mise
    moreutils
    ripgrep
    tree
    uv
    wget
  ];

  linuxPackages = with pkgs; [
    trash-cli
  ];

  macPackages = with pkgs; [
    # Currently broken due to swift build dependency: keylock
    darwin.trash
  ];

in
{
  home.username = "nick";
  home.homeDirectory =
    if pkgs.stdenv.isLinux then "/home/${config.home.username}"
    else if pkgs.stdenv.isDarwin then "/Users/${config.home.username}"
    else throw "Unsupported system";

  # home-manager version.
  home.stateVersion = "25.05";

  nixpkgs.overlays = [
    (import ./overlays/custom-packages.nix)
  ];

  home.packages = basePackages
    ++ (if pkgs.stdenv.isLinux then linuxPackages else [])
    ++ (if pkgs.stdenv.isDarwin then macPackages else []);

  home.sessionVariables = {
    # ZSH customizations to disable right hand prompt and fix colors.
    RPS1 = "";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=5";
  };

  # Program customization.
  programs.home-manager.enable = true;

  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    globalConfig = {
      settings = {
        experimental = true;
        idiomatic_version_file_enable_tools = ["python"];
      };

      tools = {
        go = "1.25.0";
        python = "3.13.7";

        "go:github.com/philippta/flyscrape/cmd/flyscrape" = "latest";
        "go:golang.org/x/vuln/cmd/govulncheck" = "latest";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Host rules.
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = if pkgs.stdenv.isDarwin
          then { "UseKeychain" = "yes"; }
          else { };
      };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      fzf-vim
      space-vim-dark
    ];

    extraConfig = builtins.readFile ./config.vim;
  };

  programs.zsh = {
    enable = true;

    # Disable the built-in plugins because zinit will manage them.
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    history = {
      append = true;
      share = true;
    };

    initContent = builtins.readFile ./zinit-settings.zsh;
  };
}
