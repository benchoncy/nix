{
  description = "Nix flake for MacOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    hostName = "bstuart-mbp-m1pro";
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      system = "${system}";
      config.allowUnfree = true;
    };
  in with pkgs; {
    darwinConfigurations = {
      "${hostName}" = nix-darwin.lib.darwinSystem {
        modules = [ 
          ./hosts/work-darwin/configuration.nix
        ];
        specialArgs = { inherit pkgs; inherit system; };
      };
    };
    darwinPackages = self.darwinConfigurations."${hostName}".pkgs;
  };
}
