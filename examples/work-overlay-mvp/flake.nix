{
  description = "Generic work wrapper flake example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    shared = {
      url = "github:benchoncy/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.follows = "shared/nix-darwin";
    home-manager.follows = "shared/home-manager";
    nur.follows = "shared/nur";
    catppuccin.follows = "shared/catppuccin";
  };

  outputs = inputs@{
    nix-darwin,
    nixpkgs,
    home-manager,
    ...
  }:
  let
    system = "aarch64-darwin";
    username = "<username>";
    hostName = "<work-host-name>";

    mkPkgs = system': import nixpkgs {
      system = system';
      overlays = [ inputs.nur.overlays.default ];
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations.${hostName} = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        inputs.shared.darwinModules.base
        ./hosts/darwin-work/configuration.nix
      ];
      specialArgs = {
        inherit inputs username;
      };
    };

    homeConfigurations."${hostName}-home" = home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        inherit inputs username;
      };
      modules = [
        inputs.shared.homeModules.base
        inputs.catppuccin.homeModules.catppuccin
        ./modules/home/default.nix
      ];
    };
  };
}
