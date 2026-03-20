{
  description = "Nix flake for NixOS/MacOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nur,
    catppuccin
  }:
  let
    mkPkgs = system: import nixpkgs {
      inherit system;
      overlays = [ inputs.nur.overlays.default ];
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
