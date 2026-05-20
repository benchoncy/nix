{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.tofu.enable {
    home.packages = with pkgs; [
      tenv
    ];

    home.sessionVariables = {
      TENV_AUTO_INSTALL = "true";
    };

    programs.zsh.shellAliases.tf = osConfig.homeProfiles.developer.tofu.alias;
  };
}
