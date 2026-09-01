{
  description = "Nix flake for NixOS/MacOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    catppuccin,
    plasma-manager
  }:
  let
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    darwinBaseModule = { ... }: {
      imports = [
        ./modules/shared
        ./modules/darwin
      ];
    };

    nixosBaseModule = { ... }: {
      imports = [
        ./modules/shared
        ./modules/nixos
      ];
    };
  in {
    darwinModules = {
      base = darwinBaseModule;
    };

    nixosModules = {
      base = nixosBaseModule;
    };

    homeModules = {
      base = ./modules/home/profiles/base.nix;
      system = ./modules/home/profiles/system.nix;
    };

    nixosConfigurations = {
      # Personal NixOS configuration
      "nixos-bstuart" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.base
          ./hosts/nixos-personal/configuration.nix
        ];
        specialArgs = {
          inherit inputs;

          hostname = "nixos-bstuart";
          username = "ben";
          displayname = "Ben Stuart";
        };
      };
    };

    homeConfigurations = {
      "nixos-bstuart-home" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          username = "ben";
        };
        modules = [
          ./modules/home/profiles/base.nix
          inputs.catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}
