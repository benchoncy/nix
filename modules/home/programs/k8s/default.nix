{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    minikube
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    kctx = "kubectx";
    kns = "kubens";
    kg = "kubectl get";
    kd = "kubectl describe";
  };

  programs.zsh.initContent = ''
    kdebug() {
      kubectl run -i --tty --rm debug --image=ubuntu --restart=Never -- sh
    }

    kexec() {
      pod=$(kubectl get pods -o name | fzf)
      kubectl exec -it $pod -- /bin/sh
    }

    klogs() {
      pod=$(kubectl get pods -o name | fzf)
      kubectl logs $pod -f
    }
  '';
}
