{ lib, inputs, ... }: {
  imports = [
    ./packages.nix
    ./options.nix
    ./home-manager.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    enable = lib.mkDefault true;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };
}
