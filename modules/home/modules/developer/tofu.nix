args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = osConfig.homeProfiles or config.homeProfiles;
in {
  config = lib.mkIf profiles.developer.tofu.enable {
    home.packages = with pkgs; [
      tenv
    ];

    home.sessionVariables = {
      TENV_AUTO_INSTALL = "true";
    };

    programs.zsh.shellAliases.tf = profiles.developer.tofu.alias;
  };
}
