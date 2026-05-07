{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.python.enable {
    home.packages = with pkgs; [
      python313
      uv
      pre-commit
    ];
  };
}