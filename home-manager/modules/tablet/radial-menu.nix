{
  pkgs,
  lib,
  tabletScripts,
  ...
}:

let
  focusOrLaunch = pkgs.writeShellScriptBin "focus-or-launch" ''
    APP_ID="$1"
    CMD="$2"
    if ${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.gnugrep}/bin/grep -qiE "\"(app_id|class)\": \"$APP_ID\""; then
      ${pkgs.sway}/bin/swaymsg "[app_id=\"(?i)$APP_ID\"] focus" 2>/dev/null || \
      ${pkgs.sway}/bin/swaymsg "[class=\"(?i)$APP_ID\"] focus" 2>/dev/null
    else
      $CMD &
    fi
  '';

  radial-open = pkgs.writeShellScriptBin "radial-open" ''
    if ${pkgs.eww}/bin/eww active-windows | ${pkgs.gnugrep}/bin/grep -q "radial-menu"; then
      ${pkgs.eww}/bin/eww close radial-menu 2>/dev/null || true
      rm -f /tmp/radial_action
    else
      rm -f /tmp/radial_action
      ${pkgs.eww}/bin/eww open radial-menu
    fi
  '';

  radial-exec = pkgs.writeShellScriptBin "radial-exec" ''
    ACTION=$(cat /tmp/radial_action 2>/dev/null)
    ${pkgs.eww}/bin/eww close radial-menu 2>/dev/null || true
    rm -f /tmp/radial_action
    case "$ACTION" in
      osk)
        ${tabletScripts.toggle-osk}/bin/toggle-osk &
        ;;
      xournalpp)
        ${focusOrLaunch}/bin/focus-or-launch "^(com\.github\.xournalpp\.xournalpp|xournalpp)$" "xournalpp" &
        ;;
      brave)
        ${focusOrLaunch}/bin/focus-or-launch "brave-browser" "brave" &
        ;;
      screenshot)
        (
          sleep 0.25
          AREA=$(${pkgs.slurp}/bin/slurp)
          if [ -n "$AREA" ]; then
            ${pkgs.grim}/bin/grim -g "$AREA" - | ${pkgs.wl-clipboard}/bin/wl-copy && \
            ${pkgs.libnotify}/bin/notify-send 'Ekran Görüntüsü' 'Seçilen alan panoya kopyalandı'
          fi
        ) &
        ;;
      rofi)
        ${pkgs.rofi}/bin/rofi -show drun &
        ;;
    esac
  '';
in
{
  home.packages = [
    pkgs.eww
    focusOrLaunch
    radial-open
    radial-exec
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    (defwindow radial-menu
      :monitor 0
      :geometry (geometry :x "0px" :y "0px" :width "348px" :height "236px" :anchor "center")
      :stacking "overlay"
      :exclusive false
      :focusable false
      (box :class "grid-container" :orientation "v" :spacing 12 :space-evenly true
        (box :class "grid-row" :orientation "h" :spacing 12 :space-evenly true
          (eventbox :onhover "echo osk > /tmp/radial_action"
                    :onhoverlost "rm -f /tmp/radial_action"
            (button :class "tile-btn" :onclick "${radial-exec}/bin/radial-exec"
              (box :orientation "v" :spacing 6 :valign "center" :halign "center"
                (label :class "tile-icon" :text "󰌌")
                (label :class "tile-text" :text "Klavye"))))
          (eventbox :onhover "echo xournal > /tmp/radial_action"
                    :onhoverlost "rm -f /tmp/radial_action"
            (button :class "tile-btn" :onclick "${radial-exec}/bin/radial-exec"
              (box :orientation "v" :spacing 6 :valign "center" :halign "center"
                (label :class "tile-icon" :text "󱓧")
                (label :class "tile-text" :text "Xournall"))))
          (eventbox :onhover "echo brave > /tmp/radial_action"
                    :onhoverlost "rm -f /tmp/radial_action"
            (button :class "tile-btn" :onclick "${radial-exec}/bin/radial-exec"
              (box :orientation "v" :spacing 6 :valign "center" :halign "center"
                (label :class "tile-icon" :text "󰖟")
                (label :class "tile-text" :text "Brave")))))
        (box :class "grid-row" :orientation "h" :spacing 12 :space-evenly true
          (eventbox :onhover "echo screenshot > /tmp/radial_action"
                    :onhoverlost "rm -f /tmp/radial_action"
            (button :class "tile-btn" :onclick "${radial-exec}/bin/radial-exec"
              (box :orientation "v" :spacing 6 :valign "center" :halign "center"
                (label :class "tile-icon" :text "󰄀")
                (label :class "tile-text" :text "SS"))))
          (eventbox :onhover "echo rofi > /tmp/radial_action"
                    :onhoverlost "rm -f /tmp/radial_action"
            (button :class "tile-btn" :onclick "${radial-exec}/bin/radial-exec"
              (box :orientation "v" :spacing 6 :valign "center" :halign "center"
                (label :class "tile-icon" :text "")
                (label :class "tile-text" :text "Rofi"))))
          (button :class "tile-btn tile-close" :onclick "${radial-open}/bin/radial-open"
            (box :orientation "v" :spacing 6 :valign "center" :halign "center"
              (label :class "tile-icon" :text "✕")
              (label :class "tile-text" :text "Kapat"))))))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font", sans-serif;
    }

    .grid-container {
      background-color: rgba(29, 32, 33, 0.94);
      border: 2px solid #d79921;
      border-radius: 16px;
      padding: 12px;
    }

    .tile-btn {
      min-width: 100px;
      min-height: 100px;
      background-color: #3c3836;
      color: #ebdbb2;
      border: 1px solid #504945;
      border-radius: 12px;
      transition: all 100ms ease;
    }

    .tile-btn:hover {
      background-color: #fabd2f;
      color: #282828;
      border-color: #fabd2f;
    }

    .tile-close {
      background-color: #32302f;
      color: #a89984;
      border-color: #3c3836;
    }

    .tile-close:hover {
      background-color: #cc241d;
      color: #fbf1c7;
      border-color: #fb4934;
    }

    .tile-icon {
      font-size: 24px;
    }

    .tile-text {
      font-size: 13px;
      font-weight: bold;
    }
  '';

  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "--locked Mod4+XF86AudioMicMute" = "exec ${radial-open}/bin/radial-open";
    "Mod3+m" = "exec ${radial-open}/bin/radial-open";
    "--release Mod3+m" = "exec ${radial-exec}/bin/radial-exec";
    "Mod3+Shift+m" = "exec ${radial-open}/bin/radial-open";
  };
}
