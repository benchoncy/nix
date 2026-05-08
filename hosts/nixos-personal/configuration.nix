{ config, pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./settings.nix                # Static settings for this host
    ../../modules/nixos 
    ../../modules/shared
  ];

  # Enable Gnome Module
  gnome.enable = true;

  # Home Manager profiles
  homeProfiles = {
    ai = {
      enable = true;
      opencode.enable = true;
      nvim.enable = true;
      providers = {
        githubCopilot.enable = true;
        supermaven.enable = true;
      };
    };
    developer.enable = true;
    developer.python.enable = true;
    developer.tofu.enable = true;
    _3dPrinting.enable = true;
  };

  system.stateVersion = "25.05";
}
