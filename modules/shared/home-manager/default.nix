{ config, pkgs, lib, inputs, username, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default # Include home-manager module
  ];

  options.home-manager.enable = lib.mkEnableOption "Home Manager Configuration";
  
  config = lib.mkIf config.home-manager.enable {
    home-manager = {
      users."${username}" = import ../../home {
        inherit config pkgs lib inputs username;
      };
      backupFileExtension = "bkp";
    };
  };
}
