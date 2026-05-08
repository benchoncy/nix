{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.containers.enable {
    home.packages = with pkgs; [
      podman
    ];
  };
}