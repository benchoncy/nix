{ config, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.github.enable {
    github.ghDash.enable = true;
  };
}
