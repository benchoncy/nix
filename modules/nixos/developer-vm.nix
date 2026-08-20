{ config, lib, username, ... }:
{
  config = lib.mkIf (config.homeProfiles.developer.enable && config.homeProfiles.developer.vms.enable) {
    virtualisation.libvirtd.enable = true;

    users.users.${username}.extraGroups = lib.mkAfter [ "libvirtd" ];
  };
}
