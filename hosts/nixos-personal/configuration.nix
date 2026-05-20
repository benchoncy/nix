{ ... }: {   
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

    # AI Policy
    ai = {
      enable = true;
      opencode.enable = true;
      nvim.enable = true;
      providers = {
        githubCopilot.enable = true;
        supermaven.enable = true;
      };
    };

    # Dev setup
    developer = {
      enable = true;
      python.enable = true;
      containers.enable = true;
      tofu.enable = true;
    };

    # Additional profiles
    _3dPrinting.enable = true;
  };

  system.stateVersion = "25.05";
}
