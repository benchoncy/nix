# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  ];
}

# Manage homebrew packages
homebrew.enable = true;
homebrew.casks = [
  displaylink
];
