{ lib, osConfig, ... }: {
  imports = lib.optionals (osConfig.homeProfiles.developer.containers.enable or false) [
    ../../programs/podman.nix
    ../../programs/k8s
  ];
}
