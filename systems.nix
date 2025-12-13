{
  "aarch64-darwin" = {
    homeDirectoryBase = "/Users";

    additionalPackages =
      pkgs: with pkgs; [
        keylock
        darwin.trash
      ];

    additionalZshConfigs = [ ./zsh/bindkeys-mac.zsh ];
  };
  "x86_64-linux" = {
    homeDirectoryBase = "/home";

    additionalPackages =
      pkgs: with pkgs; [
        trash-cli
      ];

    additionalZshConfigs = [ ];
  };
  "aarch64-linux" = {
    homeDirectoryBase = "/home";

    additionalPackages =
      pkgs: with pkgs; [
        trash-cli
      ];

    additionalZshConfigs = [ ];
  };
}
