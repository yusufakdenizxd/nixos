{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    swaybg
    grim
    slurp
    wtype
    wayfreeze
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = {
      modifier = "Mod3";
      fonts = {
        names = [
          "CaskaydiaCove Nerd Font Mono"
          "monospace"
        ];
        size = 12.0;
      };
      output = {
        "*" = {
          bg = "/home/akdeniz/Pictures/wallpaper/redsunset.jpg fill";
        };
        "HDMI-A-2" = {
          mode = "1920x1080@60Hz";
          pos = "0 0";
          scale = "1";
        };
        "eDP-1" = {
          pos = "0 1080";
          scale = "1";
        };
      };
      terminal = "ghostty";
      menu = "fuzzel";

      input = {
        "type:keyboard" = {
          xkb_options = "caps:hyper";
        };

        "2:10:TPPS/2_Elan_TrackPoint" = {
          pointer_accel = "0.2";
          accel_profile = "flat";
          scroll_method = "on_button_down";
          scroll_button = "274";
        };

        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          dwt = "enabled";
          accel_profile = "adaptive";
          pointer_accel = "0.30";
          scroll_factor = "0.45";
        };
        "type:touch" = {
          map_to_output = "eDP-1";
        };
        "type:tablet_tool" = {
          map_to_output = "eDP-1";
        };

      };

      keybindings = lib.mkOptionDefault {
        "Mod3+Return" = null;
        "Mod3+h" = "exec ${pkgs.wtype}/bin/wtype -k Left";
        "Mod3+j" = "exec ${pkgs.wtype}/bin/wtype -k Down";
        "Mod3+k" = "exec ${pkgs.wtype}/bin/wtype -k Up";
        "Mod3+l" = "exec ${pkgs.wtype}/bin/wtype -k Right";

        "Mod3+u" = "exec ${pkgs.wtype}/bin/wtype -k Prior";
        "Mod3+i" = "exec ${pkgs.wtype}/bin/wtype -k Home";
        "Mod3+o" = "exec ${pkgs.wtype}/bin/wtype -k End";
        "Mod3+p" = "exec ${pkgs.wtype}/bin/wtype -k Next";

        "Mod3+Tab" = "focus output up";
        "Mod3+Ctrl+k" = "focus output up";
        "Mod3+Ctrl+j" = "focus output down";
        "Mod3+Ctrl+Shift+k" = "move container to output up; focus output up";
        "Mod3+Ctrl+Shift+j" = "move container to output down; focus output down";

        "Print" =
          "exec --no-startup-id grim -g \"$(slurp)\" - | wl-copy && notify-send -u normal 'Ekran Görüntüsü' 'Seçilen alan panoya kopyalandı'";

        "Mod3+t" =
          "exec ${pkgs.sway}/bin/swaymsg '[app_id=\"com.mitchellh.ghostty\"] focus' || exec ${pkgs.ghostty}/bin/ghostty";
        "Mod3+f" = "fullscreen toggle";

        "Mod3+n" = "exec ${pkgs.wtype}/bin/wtype -M ctrl -k BackSpace -m ctrl";

        "--locked XF86AudioRaiseVolume" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "--locked XF86AudioLowerVolume" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "--locked XF86AudioMute" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "--locked XF86AudioMicMute" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "Mod3+F10" =
          "exec ${pkgs.bash}/bin/bash -c 'cur=$(${pkgs.brightnessctl}/bin/brightnessctl -d tpacpi::kbd_backlight g); next=$(( (cur + 1) % 3 )); ${pkgs.brightnessctl}/bin/brightnessctl -d tpacpi::kbd_backlight s $next'";

        "Mod3+space" = "exec fuzzel";
        "Mod3+v" = "exec fuzzel-clip";
        "Mod3+z" = "exec fuzzel-files";
        "Mod3+c" = "exec fuzzel-calc";
        "Mod3+period" = "exec fuzzel-emoji";

        "Mod3+a" = "workspace prev";
        "Mod3+d" = "workspace next";
        "Mod3+q" = "kill";
      };
      window = {
        border = 2;
        titlebar = false;
        hideEdgeBorders = "smart";
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      gaps = {
        outer = 0;
        inner = 0;
      };

      workspaceLayout = "default";
      bars = [ ];

      colors = {
        focused = {
          border = "#d79921";
          background = "#282828";
          text = "#ebdbb2";
          indicator = "#fabd2f";
          childBorder = "#d79921";
        };
        unfocused = {
          border = "#3c3836";
          background = "#282828";
          text = "#a89984";
          indicator = "#3c3836";
          childBorder = "#3c3836";
        };
        urgent = {
          border = "#cc241d";
          background = "#cc241d";
          text = "#ebdbb2";
          indicator = "#fb4934";
          childBorder = "#cc241d";
        };
      };
    };
  };
}
