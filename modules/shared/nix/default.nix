{ ... }: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };
}
