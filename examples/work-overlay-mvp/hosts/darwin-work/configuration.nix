{ username, ... }: {
  home-manager.users.${username}.imports = [
    ../../modules/home/default.nix
  ];

  system = {
    primaryUser = username;
    stateVersion = 6;
  };
}
