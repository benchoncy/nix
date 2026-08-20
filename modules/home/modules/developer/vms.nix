{ lib, osConfig, pkgs, ... }:
{
  config = lib.mkIf osConfig.homeProfiles.developer.vms.enable {
    home.packages = with pkgs; [
      libvirt
      vagrant
    ];
  };
}
