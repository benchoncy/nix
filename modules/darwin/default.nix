{ inputs, username, ... }: {
  imports = [
    inputs.home-manager.darwinModules.default # Include home-manager module
    ./packages.nix
  ];

  nix.enable = false; # Disable Nix management on Darwin, Determinate manages Nix

  users.users.${username} = {
    home = "/Users/${username}";
  };
}
