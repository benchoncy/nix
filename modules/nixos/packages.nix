# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ username, ... }: {
  programs._1password-gui.polkitPolicyOwners = [ "${username}" ];
}
