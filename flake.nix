{
  description = "benchoncy's nix configurations";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable  }:
  {
    # Import overlays
    overlays = import ./overlays {inherit inputs;};

    # Work darwin configuration
    # $ darwin-rebuild build --flake .#bstuart-mbp-m1pro
    darwinConfigurations."bstuart-mbp-m1pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./modules/system/darwin.nix
        ./modules/common/configuration.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
