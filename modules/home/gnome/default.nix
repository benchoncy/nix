{ lib, pkgs, username, osConfig, config, ... }: {
  
  options = {
    gnome.enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.gnome.enable or false;
      description = "Enable GNOME specific settings and packages.";
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
          disable-user-extensions = false;
          disabled-extensions = with pkgs.gnomeExtensions; [];
          enabled-extensions = with pkgs.gnomeExtensions; [
            appindicator.extensionUuid
          ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          avatar-directories = ["/home/${username}/"];
        };
        "org/gnome/desktop/background".picture-uri-dark = "file:///home/${username}/.config/userdata/wallpaper.jpg";

      };
    };

    home.file.".face".source = ../../../assets/avatar.png;
  };
}
