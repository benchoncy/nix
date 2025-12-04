{ config, pkgs, lib, inputs, username, ... }: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin # Include catppuccin theme module
    inputs.home-manager.nixosModules.default # Include home-manager module
  ];

  home-manager = {
    users."${username}".imports = [
      ../home 
      inputs.catppuccin.homeModules.catppuccin
    ];

    backupFileExtension = "bkp";
    extraSpecialArgs = {
      inherit username;
    };
  };
}
