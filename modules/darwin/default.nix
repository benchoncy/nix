{ ... }: {
  imports = [
    ./packages.nix
  ];

  nix.enable = false; # Disable Nix management on Darwin, Determinate manages Nix
}
