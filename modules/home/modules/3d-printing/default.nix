
{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles._3dPrinting.enable {
    home.packages = with pkgs; [
      cura-appimage
      curaPlugins.octoprint
      freecad
    ];
  };
}
