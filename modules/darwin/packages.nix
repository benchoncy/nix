# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }: {
  # Manage homebrew packages
  homebrew.enable = true;
  homebrew.casks = [
    "displaylink"
    "firefox"
    "languagetool-desktop"
  ];
}
