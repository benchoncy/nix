{ pkgs, inputs, username, ... }: {   
  imports = [ 
    ./hardware-configuration.nix  # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default # Include home-manager module
    ../../modules/shared
    ../../modules/nixos 
  ];
  
  home-manager.users."${username}" = import ../../modules/home-manager {
    inherit pkgs username;
  };

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

  # Install firefox.
  programs.firefox.enable = true;

  # Define system packages
  environment.systemPackages = with pkgs; [
    displaylink # for the displaylink driver
    ghostty
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  programs._1password.enable = true;
  programs._1password-gui = {
	  enable = true;
	  polkitPolicyOwners = [ "ben" ];
  };

  environment.variables = {
    CUSTOM_1P_SIGNING_PROGRAM = "${pkgs._1password-gui}/share/1password/op-ssh-sign";  # Share 1Password git signing program with chezmoi
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
