{ config, pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./settings.nix                # Static settings for this host
    ../../modules/shared
    ../../modules/nixos 
  ];

  # Enable Gnome Module
  gnome.enable = true;

  # Enable 3D Printing Module
  _3dPrinting.enable = true;

  system.stateVersion = "25.05";
}
