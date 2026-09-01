{ config, ... }: {
  imports = [
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./settings.nix                # Static settings for this host
  ];

  # Enable 16GB swap file
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MiB
    }
  ];

  # Enable KDE Plasma Module
  kde.enable = true;

  # Home Manager profiles
  homeProfiles = {

    # AI Policy
    ai = {
      enable = true;
      nvim.enable = true;
      providers = {
        githubCopilot.enable = true;
        supermaven.enable = true;
      };
    };

    # Dev setup
    developer = {
      enable = true;
      opencode.enable = true;
      python.enable = true;
      containers.enable = true;
      tofu.enable = true;
    };

    # Additional profiles
    _3dPrinting.enable = true;
  };

  system.stateVersion = "25.05";
}
