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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    hostName = "bstuart-mbp-m1pro";
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      system = "${system}";
      config.allowUnfree = true;
    };
  in with pkgs; {
    darwinConfigurations = {
      # Work MacOS configuration
      "bstuart-mbp-m1pro" = nix-darwin.lib.darwinSystem {
        modules = [ 
          ./hosts/work-darwin/configuration.nix
        ];
        specialArgs = { inherit pkgs; inherit system; };
      };
    };
    darwinPackages = self.darwinConfigurations."${hostName}".pkgs;

    nixosConfigurations = {
      # Personal NixOS configuration
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ben = ./modules/shared/home.nix;
          }
        ];
      };
    }; 
  };
}
