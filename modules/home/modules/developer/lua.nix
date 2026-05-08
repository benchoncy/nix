{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.lua.enable {
    home.packages = with pkgs; [
      lua
      luarocks
    ];
  };
}