{ config, lib, ... }: {
  options.kde.enable = lib.mkEnableOption "Enable KDE Plasma";

  config = lib.mkIf config.kde.enable {
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm.enable = lib.mkDefault true;
  };
}
