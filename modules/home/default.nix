{ pkgs, username, ... }:
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # Enable XDG Autostart
  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs._1password-gui}/share/applications/1password.desktop"
  ];

  home.stateVersion = "25.05";
}
