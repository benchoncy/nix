args@{ config, lib, ... }:
let
  osConfig = args.osConfig or {};
  profiles = args.profileConfig or (osConfig.homeProfiles or {});
in {
  imports = lib.optionals (profiles.developer.opencode.enable or false) [
    ../../programs/opencode
  ];
}
