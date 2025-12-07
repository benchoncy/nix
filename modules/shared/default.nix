{ lib, inputs, ... }: {
  imports = [
    ./packages.nix
    ./home-manager.nix
  ];

  nixpkgs = {
    overlays = [ inputs.nur.overlays.default ];
    config.allowUnfree = true;
  };

  nix = {
    enable = lib.mkDefault true;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };
}
