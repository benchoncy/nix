{
  description = "Generic work wrapper flake example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    shared = {
      url = "git+file:./shared";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.follows = "shared/nix-darwin";
    home-manager.follows = "shared/home-manager";
    catppuccin.follows = "shared/catppuccin";
    plasma-manager.follows = "shared/plasma-manager";
  };

  outputs = inputs@{
    nix-darwin,
    nixpkgs,
    home-manager,
    ...
  }: {
    darwinConfigurations."<work-host-name>" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        inputs.shared.darwinModules.base
        ./hosts/darwin-work/configuration.nix
      ];
      specialArgs = {
        inherit inputs;
        hostname = "<work-host-name>";
        username = "<username>";
        displayname = "<Your Name>";
      };
    };

    nixosConfigurations."<nixos-host-name>" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.shared.nixosModules.base
        ./hosts/nixos-work/configuration.nix
      ];
      specialArgs = {
        inherit inputs;
        hostname = "<nixos-host-name>";
        username = "<username>";
        displayname = "<Your Name>";
      };
    };

    homeConfigurations."<work-host-name>-home" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs;
        hostname = "<work-host-name>";
        username = "<username>";
        displayname = "<Your Name>";
      };
      modules = [
        inputs.shared.homeModules.base
        inputs.catppuccin.homeModules.catppuccin
        ./modules/home/default.nix
        ({ ... }: {
          home.username = "<username>";
          home.homeDirectory = "/Users/<username>";
          home.stateVersion = "26.05";
        })
      ];
    };
  };
}
