{
  config,
  inputs,
  pkgs,
  lib,
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
    basedpyright
    fzf
    git
    gnused
    gopls
    htop
    ijq
    jless
    jq
    kubectl
    lazygit
    mergiraf
    mise
    moreutils
    ripgrep
    shellcheck
    tree
    wget
  ];

  # Shell script wrapping the 1Password CLI. On WSL, locate and run the
  # Windows-installed op.exe; otherwise fall back to the nix-installed binary.
  opWrapper = pkgs.writeShellScriptBin "op" ''
    if command -v wslpath > /dev/null && command -v wslvar > /dev/null; then
      # Find base folder for 1Password CLI in current user's Windows WinGet Packages
      WIN_USER_PATH="$(wslpath "$(wslvar USERPROFILE 2> /dev/null)")"
      WIN_OP_BASE="$WIN_USER_PATH/AppData/Local/Microsoft/WinGet/Packages"

      # Find the latest folder matching the pattern (AgileBits.1Password.CLI*)
      OP_DIR=$(ls -td "$WIN_OP_BASE"/AgileBits.1Password.CLI* 2> /dev/null | head -n1)

      if [ -z "$OP_DIR" ]; then
        echo "[ERROR] Could not find 1Password CLI folder in $WIN_OP_BASE" >&2
        exit 1
      fi

      mapfile -d "" op_env_vars < <(env -0 | grep -z ^OP_ | cut -z -d= -f1)
      export WSLENV="''${WSLENV:-}:$(IFS=:; echo "''${op_env_vars[*]}")"
      exec "$OP_DIR/op.exe" "$@"
    else
      exec ${pkgs._1password-cli}/bin/op "$@"
    fi
  '';

in
{
  home.username = "nick";
  home.homeDirectory = "${systemConfig.homeDirectoryBase}/${config.home.username}";

  # home-manager version.
  home.stateVersion = "26.05";

  accounts.calendar.basePath = ".local/share/calendar";

  # Patch for some weird behavior where home-manager seems to get confused about
  # whether the crush.json file is actually managed by home-manager, so it bails
  # early if the file exists already (e.g. from a prior generation). This is a fix
  # to remove the file before checking the existence of target file.
  home.activation.removeCrushConfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.config/crush/crush.json
  '';

  home.packages =
    basePackages
    ++ (systemConfig.additionalPackages pkgs)
    ++ (pkgs.lib.optionals isLinux [ opWrapper ]);

  home.sessionVariables = {
    # ZSH customizations to disable right hand prompt and fix colors.
    RPS1 = "";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=5";
  };

  news.display = "silent";

  # Program customization.
  programs.home-manager.enable = true;

  programs.crush = {
    enable = true;
    settings = {
      lsp = {
        go = {
          command = "gopls";
        };
        python = {
          command = "basedpyright-langserver";
          args = [ "--stdio" ];
        };
      };
      permissions = {
        allowed_tools = [
          "glob"
          "grep"
          "ls"
          "lsp_diagnostics"
          "lsp_references"
          "todos"
          "view"
        ];
      };
      providers = {
        openrouter = {
          name = "openrouter";
          id = "openrouter";
          api_key = "$(op item get 'OpenRouter API Key' --field credential --reveal)";
          models = [ ];
        };
      };
    };
  };

  programs.helix = {
    enable = true;
    package = pkgs.evil-helix;

    extraPackages = with pkgs; [
      # Go
      golangci-lint

      # Python
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
            "basedpyright"
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
    systemd.enable = false;

    package = null; # Separate installation.

    enableZshIntegration = true;

    settings = {
      cursor-style = "block";
      font-size = 16;
      macos-icon = "official";
      macos-titlebar-style = "tabs";
      mouse-hide-while-typing = true;
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "no-bell,notify";
      notify-on-command-finish-after = "15s";
      shell-integration-features = "no-cursor,ssh-terminfo";
      theme = "0x96f";
      window-colorspace = "display-p3";
    };
  };

  programs.git = {
    enable = true;

    attributes =
      let
        gitattributesContent = pkgs.runCommand "mergiraf-gitattributes" { } ''
          ${pkgs.mergiraf}/bin/mergiraf languages --gitattributes > $out
        '';
      in
      pkgs.lib.splitString "\n" (builtins.readFile gitattributesContent);

    ignores = [
      "*.swp"
      ".DS_Store"
      "mise.local.toml"
    ];

    settings = {
      core = {
        editor = "hx";
      };

      init = {
        defaultBranch = "main";
      };

      merge = {
        conflictStyle = "diff3";

        mergiraf = {
          name = "mergiraf";
          driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
        };
      };

      pager = {
        show = "less -N";
      };

      pull = {
        rebase = true;
      };

      rebase = {
        autoStash = true;
      };

      user = {
        name = "Nick Pleatsikas";
        email = "nick@pleatsikas.me";
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
        go = "1.26.5";
        python = "3.14.6";

        "go:github.com/philippta/flyscrape/cmd/flyscrape" = "latest";
        "go:golang.org/x/vuln/cmd/govulncheck" = "latest";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Enable orbstack ssh config on mac.
    includes = if isDarwin then [ "~/.orbstack/ssh/config" ] else [ ];

    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
      }
      // (if isDarwin then { UseKeychain = "yes"; } else { });
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.uv = {
    enable = true;

    settings = {
      exclude-newer = "2d";
    };
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
      rr = "git rev-parse --show-toplevel";
      cr = "cd $(rr)";
    };

    initContent =
      (builtins.readFile ./zsh/zinit-settings.zsh)
      + (builtins.readFile ./zsh/bindkeys-common.zsh)
      + (pkgs.lib.concatMapStrings (f: "\n" + (builtins.readFile f)) systemConfig.additionalZshConfigs);
  };
}
