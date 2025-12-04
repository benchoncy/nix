{ config, pkgs, lib, ... }: {
  options.gnome.enable = lib.mkEnableOption "Enable Gnome";
  
  config = lib.mkIf config.gnome.enable {
    services.desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
      '';
    };

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    environment.gnome.excludePackages = (with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]);

    # Enable gdm display manager
    services.displayManager = {
      gdm = {
        enable = lib.mkDefault true;
        wayland = true;
      };
    };
  };
}
