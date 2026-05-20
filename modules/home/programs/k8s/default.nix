{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    minikube
  ];

  home.file.".config/shell/tools/k8s.sh".source = ./shell/k8s.sh;
}
