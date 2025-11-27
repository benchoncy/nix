{ lib, ... }: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = lib.mkDefault true;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };
}
