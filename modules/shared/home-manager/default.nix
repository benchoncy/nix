{ pkgs, inputs, username, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default # Include home-manager module
  ];
  
  home-manager.users."${username}" = import ../../home {
    inherit pkgs username;
  };
}
