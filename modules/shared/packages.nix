# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }: {
  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  environment.variables = {
    CUSTOM_1P_SIGNING_PROGRAM = "${pkgs._1password-gui}/share/1password/op-ssh-sign";  # Share 1Password git signing program with home-manager
  };
}
