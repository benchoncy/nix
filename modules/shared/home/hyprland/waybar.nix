{ ... }: {
  programs.waybar = {
    enable = true;

    settings.main = {
      layer = "top";
      position = "top";
      height = 32;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "battery" "tray" "bluetooth" "network" ];
      

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "●";
          "2" = "●";
          "3" = "●";
          "4" = "●";
          "5" = "●";
          "6" = "●";
          "7" = "●";
          "8" = "●";
          "9" = "●";
          "10" = "●";
          active = "●";
          urgent = "●";
          persistent = "●";
          focused = "●";
          default = "";
        };
      };

      clock = {
        tooltip-format = "{:%A, %B %d, %Y}";
      };

      battery = {
        format = "{icon}  {capacity}%";
        format-charging = "⚡ {capacity}%";
        format-full = "{icon}  Full";
        format-icons = [ "" "" "" "" "" ];
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "{icon}  Muted";
        format-icons = [ "" "" "" "" ];
      };

      bluetooth = {
        format = "  ";
        format-disabled = "";
        format-no-controller = "";
      };

      network = {
        format-wifi= "  ";
        format-ethernet = "  ";
        format-disconnected = "  ";
        tooltip-format = "{ifname}: {essid} {signalStrength}%";
      };
    };

    style = "
      * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 14px;
        min-height: 0;
        padding-right: 2px;
        padding-left: 2px;
        padding-bottom: 0px;
      }

      #waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 5px 5px 0 5px;
        padding: 5px 1rem;
        background-color: @surface0;
        border-radius: 1rem;
      }

      .modules-left {
        margin-left: 1rem;
      }

      .modules-right {
        margin-right: 1rem;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0.1rem;
      }

      #workspaces button.active {
        color: @peach;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        background-color: @surface0;
        border-radius: 1rem;
        color: @sapphire;
      }

      #workspaces button.empty:not(.active) {
        color: @surface2;
        border-radius: 1rem;
      }

      #clock,
      #network,
      #bluetooth,
      #language {
        color: @text;
      }

      #battery,
      #pulseaudio,
      #bluetooth,
      #tray {
        margin-right: 0.5rem;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #pulseaudio {
        color: @rosewater;
      }

      #tray {
        color: @text;
        margin-right: 1rem;
        border-radius: 1rem;
      }

      tooltip {
        font-size: 12px;
        padding: 0.2rem 0.5rem;
        border-radius: 0.5rem;
        background-color: @surface0;
        color: @text;
      }
    ";
  };
}
