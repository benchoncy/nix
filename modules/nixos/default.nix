{ inputs, hostname, username, displayname, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default # Include home-manager module
    inputs.catppuccin.nixosModules.catppuccin # Include catppuccin theme module
    ./packages.nix
    ./display
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostname;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Setup user account.
  users.users.${username} = {
    isNormalUser = true;
    description = "${displayname}";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$PEaenklbBc4q03wf$QEWk29c/LTnucySq0Vs2nXgB19jEJ2IlypODbKWuBScBIDPXsbQe1gJK4Z9x.Tr0D6PUpC5aezd/zZbsroaNK.";
  };
}
