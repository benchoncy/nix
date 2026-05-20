{ lib, pkgs, osConfig, ... }:
let
  k8sShellHelper = ./containers/config/shell/tools/k8s.sh;
in {
  config = lib.mkIf osConfig.homeProfiles.developer.containers.enable {
    home.packages = with pkgs; [
      podman
      kubectl
      kubectx
      minikube
    ];

    home.file.".config/shell/tools/k8s.sh".source = k8sShellHelper;
  };
}
