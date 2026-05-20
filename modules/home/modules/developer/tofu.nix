{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.tofu.enable {
    home.packages = with pkgs; [
      tenv
    ];
    home.sessionVariables = {
      TENV_AUTO_INSTALL = "true";
    };

    home.file.".config/shell/tools/tf.sh".text = ''
      if [ -x "$(command -v terraform)" ]; then
          alias tf="terraform"
      else
          alias tf="tofu"
      fi
    '';
  };
}
