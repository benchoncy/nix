{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.aws.enable {
    home.packages = with pkgs; [
      awscli2
    ];

    home.file = {
      ".aws/cli/alias".source = ./aws/config/cli/alias;
    };
  };
}
