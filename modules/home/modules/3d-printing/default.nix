
args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = osConfig.homeProfiles or config.homeProfiles;
in {
  config = lib.mkIf profiles._3dPrinting.enable {
    home.packages = with pkgs; [
      cura-appimage
      freecad
    ];
  };
}
