{
  config,
  pkgs,
  lib,
  ...
}:

let
  tabletScripts = import ./scripts.nix { inherit pkgs; };
in
{
  imports = [
    (import ./radial-menu.nix { inherit pkgs lib tabletScripts; })
  ];

  home.packages = tabletScripts.packages;

  systemd.user.services.lisgd = {
    Unit = {
      Description = "Touchscreen gesture daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${tabletScripts.start-touch-gestures}/bin/start-touch-gestures";
      Restart = "always";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.sway = {
    config = {
      input = {
        "type:touch" = {
          map_to_output = "eDP-1";
        };
        "type:tablet_tool" = {
          map_to_output = "eDP-1";
        };
      };

      startup = [
        { command = "${pkgs.eww}/bin/eww daemon"; }
      ];
    };

    extraConfig = ''
      bindswitch --reload --locked tablet:on exec ${tabletScripts.on-tablet-mode}/bin/on-tablet-mode
      bindswitch --reload --locked tablet:off exec ${tabletScripts.off-tablet-mode}/bin/off-tablet-mode
    '';
  };
}
