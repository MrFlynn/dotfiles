{
  description = "Nick's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nur.overlays.default
          self.overlays.default
        ];
      };
    in
    {
      overlays.default = import ./overlays/custom-packages.nix inputs;

      homeConfigurations."nick" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };
    };
}
