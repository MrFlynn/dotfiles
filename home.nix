{
  config,
  inputs,
  pkgs,
  currentSystem,
  systemConfig,
  ...
}:

let
  isLinux = builtins.elem currentSystem [
    "x86_64-linux"
    "aarch64-linux"
  ];
  isDarwin = builtins.elem currentSystem [
    "aarch64-darwin"
  ];

  basePackages = with pkgs; [
    fzf
    git
    gnused
    htop
    ijq
    jless
    jq
    kubectl
    lazygit
    mise
    moreutils
    ripgrep
    shellcheck
    tree
    uv
    wget
  ];

in
{
  home.username = "nick";
  home.homeDirectory = "${systemConfig.homeDirectoryBase}/${config.home.username}";

  # home-manager version.
  home.stateVersion = "25.05";

  accounts.calendar.basePath = ".local/share/calendar";

  programs.crush = {
    enable = true;
    settings = {
      providers = {
        openrouter = {
          name = "openrouter";
          id = "openrouter";
          api_key = "$(op item get 'OpenRouter API Key' --field credential --reveal)";
        };
      };
    };
  };

  home.packages = basePackages ++ (systemConfig.additionalPackages pkgs);

  home.sessionVariables = {
    # ZSH customizations to disable right hand prompt and fix colors.
    RPS1 = "";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=5";
  };

  news.display = "silent";

  # Program customization.
  programs.home-manager.enable = true;

  programs.helix = {
    enable = true;
    package = pkgs.evil-helix;

    extraPackages = with pkgs; [
      # Go
      gopls
      golangci-lint

      # Python
      pyright
      ruff

      # Shell
      shfmt

      # Yaml
      yaml-language-server
      yamlfmt
    ];

    languages = {
      language = [
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "shfmt";
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "pyright"
            "ruff"
          ];
        }
      ];

      language-server = {
        yaml-language-server = {
          config.yaml = {
            schemaStore.enable = true;
            schemaStore.url = "https://www.schemastore.org/api/json/catalog.json";

            schemas = {
              kubernetes = "*.yaml";
            };
          };
        };
      };
    };

    settings = {
      theme = "jellybeans";
    };
  };

  programs.ghostty = {
    enable = true;
    package = null; # Separate installation.

    enableZshIntegration = true;

    settings = {
      cursor-style = "block";
      font-size = 16;
      macos-icon = "glass";
      macos-titlebar-style = "tabs";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor,ssh-terminfo";
      theme = "0x96f";
      window-colorspace = "display-p3";
    };
  };

  programs.git = {
    enable = true;

    ignores = [
      "*.swp"
      ".DS_Store"
    ];

    settings = {
      user = {
        name = "Nick Pleatsikas";
        email = "nick@pleatsikas.me";
      };

      core = {
        editor = "hx";
      };

      init = {
        defaultBranch = "main";
      };

      pager = {
        show = "less -N";
      };

      pull = {
        rebase = true;
      };
    };
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    globalConfig = {
      settings = {
        experimental = true;
        idiomatic_version_file_enable_tools = [ "python" ];
      };

      tools = {
        go = "1.25.0";
        python = "3.14.0";

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
        extraOptions = if isDarwin then { "UseKeychain" = "yes"; } else { };
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
      vim-visual-multi
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

    shellAliases = {
      less = "less -SN --use-color";
      reload = "source ~/.zshrc";
    };

    siteFunctions =
      if isDarwin then
        {
          notify = ''
            osascript -e "display notification \"$1\" with title \"Command finished\""
          '';
        }
      else
        { };

    initContent =
      (builtins.readFile ./zsh/zinit-settings.zsh)
      + (builtins.readFile ./zsh/bindkeys-common.zsh)
      + (pkgs.lib.concatMapStrings (f: "\n" + (builtins.readFile f)) systemConfig.additionalZshConfigs);
  };
}
