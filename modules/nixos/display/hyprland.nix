{ config, pkgs, lib, ... }: {
  options.hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
    };

    # Install additional packages
    environment.systemPackages = with pkgs; [
      wofi
    ];
    
    # Enable ly display manager
    services.displayManager.ly.enable = lib.mkDefault true;
  };
}
