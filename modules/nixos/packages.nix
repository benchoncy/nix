# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ghostty
    displaylink # for the displaylink driver
  ];
}
