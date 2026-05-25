# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ ... }: {
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
}
