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
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    catppuccin
  }:
  {
    darwinConfigurations = {
      # Work MacOS configuration
      "bstuart-mbp-m1pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          ./hosts/darwin-work/configuration.nix
        ];
        specialArgs = {
          inherit inputs;

          username = "bstuart";
        };
      };
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
  };
}
