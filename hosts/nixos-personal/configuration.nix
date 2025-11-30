{ config, pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./settings.nix                # Static settings for this host
    ../../modules/shared
    ../../modules/nixos 
  ];

  # Enable hyprland Module
  hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    # Place bespoke packages here if needed
  ];
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  environment.variables = {
    CUSTOM_1P_SIGNING_PROGRAM = "${pkgs._1password-gui}/share/1password/op-ssh-sign";  # Share 1Password git signing program with chezmoi
  };

  system.stateVersion = "25.05";
}
