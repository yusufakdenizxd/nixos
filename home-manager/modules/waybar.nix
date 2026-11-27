{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";
        height = 28;
        spacing = 2;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "backlight"
          "bluetooth"
          "network"
          "battery"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        clock = {
          format = "{:%d.%m %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        tray = {
          icon-size = 15;
          spacing = 6;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
        };

        bluetooth = {
          format = "󰂯";
          format-connected = "󰂱";
          format-disabled = "󰂲";
          tooltip-format = "{controller_alias}\t{status}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_battery_percentage}%";
          on-click = "swaymsg exec 'bzmenu -l fuzzel'";
          on-click-right = "overskride";
        };

        network = {
          format-wifi = "󰤨";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip-format = "{essid} ({ipaddr})";
          on-click = "swaymsg exec networkmanager_dmenu";
        };

        battery = {
          states = {
            tooMuch = 95;
            good = 80;
            meh = 50;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰁹"
          ];
        };
      };
    };

    style = ''
      *:not(tooltip):not(menu):not(menuitem):not(check):not(radio):not(separator) {
        all: unset;
      }

      window#waybar {
        background-color: #282828;
        color: #ebdbb2;
        border-top: 1px solid #3c3836;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        margin: 2px;
        padding: 0 6px;
        border-radius: 3px;
        color: #689d6a;
      }

      #workspaces button.focused {
        color: #282828;
        background: #98971a;
      }

      #workspaces button.urgent {
        color: #fb4934;
      }

      #workspaces button:hover {
        box-shadow: 0 0 0 1px #98971a;
      }

      #clock {
        padding: 0 8px;
        color: #ebdbb2;
        font-weight: bold;
      }

      #tray,
      #pulseaudio,
      #backlight,
      #bluetooth,
      #network,
      #battery {
        margin: 2px 3px;
        padding: 0 5px;
      }

      #tray {
        color: #ebdbb2;
      }

      #pulseaudio {
        color: #689d6a;
      }

      #backlight {
        color: #ebdbb2;
      }

      #backlight.4, #backlight.3, #backlight.2, #backlight.1 {
        color: #d56d0e;
      }

      #bluetooth {
        color: #83a598;
      }

      #network {
        color: #a89984;
      }

      #custom-osk {
        color: #fabd2f;
        background-color: #3c3836;
        padding: 0 8px;
        margin: 3px 4px;
        border-radius: 4px;
        font-size: 13px;
      }

      #custom-osk:hover {
        background-color: #d79921;
        color: #282828;
      }

      #battery.tooMuch {
        color: #bfff64;
      }

      #battery.good {
        color: #5cff5c;
      }

      #battery.meh {
        color: #bfff64;
      }

      #battery.warning {
        color: #fc9b5a;
      }

      #battery.critical {
        color: #e33d3d;
      }

      #battery.charging, #battery.plugged {
        color: #64ff64;
      }

      #battery.charging.tooMuch, #battery.plugged.tooMuch, #battery.full {
        color: #bfff64;
      }
    '';
  };
}
