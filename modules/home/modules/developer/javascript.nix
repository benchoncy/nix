{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.javascript.enable {
    home.packages = with pkgs; [
      nodejs_24
    ];
  };
}