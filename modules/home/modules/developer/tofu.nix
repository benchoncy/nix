{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.tofu.enable {
    home.packages = with pkgs; [
      tenv
    ];
  };
}
