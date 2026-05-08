{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.rust.enable {
    home.packages = with pkgs; [
      cargo
      rust
    ];
  };
}