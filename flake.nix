{
  description = "Nick's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:charmbracelet/nur";
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
      home-manager,
      nur,
      ...
    }@inputs:
    let
      systemConfigs = import ./systems.nix;
      systems = builtins.attrNames systemConfigs;

      mkHomeConfig =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              self.overlays.default
            ];
          };
          systemConfig = systemConfigs.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs systemConfig;
            currentSystem = system;
          };
          modules = [
            ./home.nix
            nur.homeModules.crush
          ];
        };
    in
    {
      overlays.default = import ./overlays/custom-packages.nix inputs;

      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = "nick-${system}";
          value = mkHomeConfig system;
        }) systems
      );
    };
}
