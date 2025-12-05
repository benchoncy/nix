{ config, lib, pkgs, username, osConfig, ... }: {
  
  options = {
    gnome.enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.gnome.enable or false;
      description = "Enable GNOME specific settings and packages.";
    };
    gnome.favoriteApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "1password.desktop"
        "obsidian.desktop"
        "zotero.desktop"
      ];
      description = "List of favorite applications to show in the GNOME dock.";
    };
  };

  config = lib.mkIf config.gnome.enable {
    home.packages = with pkgs; [
      dconf-editor
      gnomeExtensions.appindicator
    ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disabled-extensions = with pkgs.gnomeExtensions; [];
          enabled-extensions = with pkgs.gnomeExtensions; [
            appindicator.extensionUuid
          ];

          favorite-apps = config.gnome.favoriteApps;
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          avatar-directories = ["/home/${username}/"];
          gtk-theme = "Adwaita";
          icon-theme = "Adwaita";
          cursor-theme = "Adwaita";
        };
        "org/gnome/desktop/background".picture-uri-dark = "file:///home/${username}/.config/userdata/wallpaper.jpg";

      };
    };

    home.file.".face".source = ../../../assets/avatar.png;
  };
}
