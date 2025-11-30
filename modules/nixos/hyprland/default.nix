{ config, pkgs, lib, ... }: {
  options.hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
    };

    # Enable kitty as is the default terminal in hyprland
    environment.systemPackages = with pkgs; [
      kitty
      wofi
    ];
    
    # Enable ly display manager
    services.displayManager.ly.enable = true;
  };
}
