{ config, pkgs, ... }:
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # Enable XDG Autostart
  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs._1password-gui}/share/applications/1password.desktop"
  ];

  home.stateVersion = "25.05";
}
