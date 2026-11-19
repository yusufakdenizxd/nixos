{
  pkgs,
  lib,
  tabletScripts,
}:

let
  focusOrLaunch =
    appId: bin:
    "${pkgs.sway}/bin/swaymsg '[app_id=${appId}] focus' || ${pkgs.sway}/bin/swaymsg exec ${bin}";

  takeScreenshot = pkgs.writeShellScriptBin "dock-screenshot" ''
    # Dokunma olayinin (touch-up) slurp'u tetiklememesi icin parmagin kalkmasini bekle
    sleep 0.5

    GEOM=$(${pkgs.slurp}/bin/slurp 2>/dev/null)
    STATUS=$?

    if [ $STATUS -eq 0 ] && [ -n "$GEOM" ]; then
      if ${pkgs.grim}/bin/grim -g "$GEOM" - | ${pkgs.wl-clipboard}/bin/wl-copy; then
        ${pkgs.libnotify}/bin/notify-send -u normal "Ekran Görüntüsü" "Seçilen alan panoya kopyalandı"
      else
        ${pkgs.libnotify}/bin/notify-send -u critical "Ekran Görüntüsü Hatası" "grim panoya kopyalayamadı"
      fi
    fi
  '';

  dockButtons = [
    {
      icon = "󰄀";
      cmd = "${pkgs.sway}/bin/swaymsg exec ${takeScreenshot}/bin/dock-screenshot";
    }
    {
      icon = "󰖟";
      cmd = focusOrLaunch "brave-browser" "${pkgs.brave}/bin/brave";
    }
    {
      icon = "󰆒";
      cmd = "${pkgs.wtype}/bin/wtype -M ctrl -k v -m ctrl";
    }
    {
      icon = "󰆏";
      cmd = "${pkgs.wtype}/bin/wtype -M ctrl -k c -m ctrl";
    }
    {
      icon = "󰏫";
      cmd = focusOrLaunch "com.github.xournalpp.xournalpp" "${pkgs.xournalpp}/bin/xournalpp";
    }
    {
      icon = "⌨";
      cmd = "${tabletScripts.toggle-osk}/bin/toggle-osk &";
    }
  ];

  escapeYuck = s: builtins.replaceStrings [ ''"'' ] [ ''\"'' ] s;

  renderButtons = lib.concatMapStringsSep "\n    " (
    b: ''(button :class "dock-btn" :onclick "${escapeYuck b.cmd}" "${b.icon}")''
  ) dockButtons;
in
{
  xdg.configFile."eww/eww.yuck".text = ''
    (defwindow tablet-dock
      :monitor 0
      :geometry (geometry :x "0px"
                          :y "0px"
                          :width "64px"
                          :height "100%"
                          :anchor "left center")
      :stacking "fg"
      :exclusive true
      :focusable false
      (box :class "dock-container"
           :orientation "v"
           :space-evenly true
           :valign "fill"
        ${renderButtons}))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "JetBrainsMono Nerd Font", monospace;
    }

    .dock-container {
      background-color: #282828;
      border-right: 1px solid #3c3836;
      padding: 10px 6px;
    }

    .dock-btn,
    .dock-btn:hover,
    .dock-btn:focus {
      background-color: #3c3836;
      color: #ebdbb2;
      border-radius: 6px;
      margin: 6px 2px;
      font-size: 22px;
      font-weight: bold;
      box-shadow: none;
      outline: none;
      transition: background-color 120ms ease, color 120ms ease;
    }

    .dock-btn:active {
      background-color: #d79921;
      color: #282828;
    }
  '';
}
