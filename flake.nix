{
  description = "Nick's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom packages
    keylock-src = {
      url = "github:kfv/keylock/d808c1651d65c3159a8902481e8c75c8aa5c807f";
      flake = false;
    };

    space-vim-dark-src = {
      url = "github:liuchengxu/space-vim-dark/0ab698bd2a3959e3bed7691ac55ba4d8abefd143";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      llm-agents,
      home-manager,
      ...
    }@inputs:
    {
      overlays.default = import ./overlays/custom-packages.nix inputs;

      homeConfigurations = nixpkgs.lib.mapAttrs' (
        system: systemConfig:
        nixpkgs.lib.nameValuePair "nick-${system}" (
          home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                self.overlays.default
                llm-agents.overlays.shared-nixpkgs
              ];
            };
            extraSpecialArgs = { inherit systemConfig; };
            modules = [ ./home.nix ];
          }
        )
      ) (import ./systems.nix);
    };
}
