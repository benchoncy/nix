{ lib, osConfig, ... }: {
  imports = lib.optionals (osConfig.homeProfiles.developer.github.enable or false) [
    ../../programs/github
  ];
}
