args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = osConfig.homeProfiles or config.homeProfiles;
in {
  config = lib.mkIf profiles.developer.rust.enable {
    home.packages = with pkgs; [
      cargo
      rust
    ];
  };
}
