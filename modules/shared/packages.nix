# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, username, ... }: {
  environment.systemPackages = with pkgs; [
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
	  enable = true;
	  polkitPolicyOwners = [ "${username}" ];
  };

  environment.variables = {
    CUSTOM_1P_SIGNING_PROGRAM = "${pkgs._1password-gui}/share/1password/op-ssh-sign";  # Share 1Password git signing program with home-manager
  };
}
