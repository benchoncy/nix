{ pkgs, ... }:
let
  username = "ben";
in
{
  imports = [
    ../catppuccin.nix
    ./hyprland
  ];

  home.username = "${username}";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # Enable XDG Autostart
  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs._1password-gui}/share/applications/1password.desktop"
  ]; 

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  
  home.stateVersion = "25.05";
}
