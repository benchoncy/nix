{ config, pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    ../../modules/shared
    ../../modules/nixos 
  ];

  # Enable Home Manager Module
  home-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # Place bespoke packages here if needed
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure video drivers
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";
  
  environment.variables = {
    CUSTOM_1P_SIGNING_PROGRAM = "${pkgs._1password-gui}/share/1password/op-ssh-sign";  # Share 1Password git signing program with chezmoi
  };

  system.stateVersion = "25.05";
}
