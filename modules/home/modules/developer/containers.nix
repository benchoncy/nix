args@{ config, lib, ... }:
let
  osConfig = args.osConfig or {};
  profiles = args.profileConfig or (osConfig.homeProfiles or {});
in {
  imports = lib.optionals (profiles.developer.containers.enable or false) [
    ../../programs/podman.nix
    ../../programs/k8s
  ];
}
