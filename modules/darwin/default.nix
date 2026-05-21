{ inputs, username, ... }: {
  imports = [
    inputs.home-manager.darwinModules.default # Include home-manager module
    ./packages.nix
  ];

  nix.enable = false; # Disable Nix management on Darwin, Determinate manages Nix

  # Enable TouchID for sudo (also enables Apple Watch)
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  users.users.${username} = {
    home = "/Users/${username}";
  };
}
