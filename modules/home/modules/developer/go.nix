{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.go.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}