{ lib, osConfig, ... }: {
  imports = lib.optionals (osConfig.homeProfiles.developer.opencode.enable or false) [
    ../../programs/opencode
  ];
}
