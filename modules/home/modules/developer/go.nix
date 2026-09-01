args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = osConfig.homeProfiles or config.homeProfiles;
in {
  config = lib.mkIf profiles.developer.go.enable {
    home.packages = with pkgs; [
      go
    ];

    home.sessionVariables = {
      GOPATH = "$HOME/.go";
      PATH = "$PATH:$HOME/.go/bin";
    };
  };
}
