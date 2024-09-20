# Common configuration
{ inputs, pkgs, ... }: {
  nixpkgs = {
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
    overlays = [
      inputs.self.overlays.unstable-packages
    ];
  };

  environment.systemPackages = with pkgs; [
    # Basics
    git
    wget
    curl
    gnutar
    unzip
    fzf
    rsync
    jq
    yq
    unstable.neovim
    # Development
    ## Python
    python3
    uv
    ## AWS
    awscli2
    ## K8s
    kubectl
    kubectx
    kns
    ## Terraform
    tenv
    # Other
    chezmoi
    _1password
    _1password-gui
  ];
}
