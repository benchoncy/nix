{ username, ... }:
{
  homeProfiles.developer.enable = true;

  home-manager.users.${username}.imports = [
    ../../modules/home/default.nix
  ];

  system.stateVersion = "26.05";
}
