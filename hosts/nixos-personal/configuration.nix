{ config, pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./settings.nix                # Static settings for this host
    ../../modules/shared
    ../../modules/nixos 
  ];

  # Enable Gnome Module
  gnome.enable = true;

  environment.systemPackages = with pkgs; [
    # Place bespoke packages here if needed
  ]; 

  system.stateVersion = "25.05";
}
