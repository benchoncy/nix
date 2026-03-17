{ pkgs, username, ... }: {
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs._1password-gui}/share/applications/1password.desktop"
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
