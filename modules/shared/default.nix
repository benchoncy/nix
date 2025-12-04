{ lib, ... }: {
  imports = [
    ./packages.nix
    ./home-manager.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = lib.mkDefault true;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };
}
