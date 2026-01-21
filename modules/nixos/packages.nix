# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ username, pkgs, ... }: {
  programs._1password-gui.polkitPolicyOwners = [ "${username}" ];

  environment.systemPackages = with pkgs; [
    vlc
  ];
}
