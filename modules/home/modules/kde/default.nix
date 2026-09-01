args@{ config, lib, username, ... }:
let
  osConfig = args.osConfig or {};
in {
  options = {
    kde.enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.kde.enable or false;
      description = "Enable KDE Plasma specific settings.";
    };

    kde.taskbarApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "org.kde.dolphin.desktop"
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "obsidian.desktop"
        "1password.desktop"
        "zotero.desktop"
      ];
      description = "Desktop file IDs for applications pinned to the Plasma taskbar.";
    };
  };

  config = lib.mkIf config.kde.enable {
    programs.plasma = {
      enable = true;
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        wallpaper = "/home/${username}/.config/userdata/wallpaper.jpg";
      };
      panels = [
        {
          location = "bottom";
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            {
              iconTasks.launchers = map (app: "applications:${app}") config.kde.taskbarApps;
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
  };
}
