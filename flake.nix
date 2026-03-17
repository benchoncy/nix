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

    workRepoPath = "/Users/bstuart/.work-dotfiles";
    workModulePath = "${workRepoPath}/modules/home/default.nix";
  in {
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

    homeConfigurations = {
      "bstuart-mbp-m1pro-home" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "aarch64-darwin";
        extraSpecialArgs = {
          inherit inputs;
          username = "bstuart";
        };
        modules = [
          ./modules/home/profiles/standalone-work.nix
          inputs.catppuccin.homeModules.catppuccin
          {
            my.work.repoPath = workRepoPath;
          }
        ] ++ (if builtins.pathExists workModulePath then [ workModulePath ] else [ ]);
      };

      "nixos-bstuart-home" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          username = "ben";
        };
        modules = [
          ./modules/home/profiles/standalone-personal.nix
          inputs.catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}
