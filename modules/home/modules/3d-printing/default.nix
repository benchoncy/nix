
{ config, lib, pkgs, osConfig, ... }: {
  
  options = {
    _3dPrinting.enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig._3dPrinting.enable or false;
      description = "Enable 3D printing specific settings and packages.";
    };
  };

  config = lib.mkIf config._3dPrinting.enable {
    home.packages = with pkgs; [
      cura-appimage
      curaPlugins.octoprint
      freecad
    ];
  };
}
