{ pkgs, ... }:

let
  wvkbdCmd = ''
    ${pkgs.wvkbd}/bin/wvkbd-mobintl \
      --non-exclusive \
      -l full,special \
      --landscape-layers full,special \
      -H 560 \
      -L 340 \
      -R 10 \
      --alpha 255 \
      --bg 282828 \
      --fg 3c3836 \
      --fg-sp 504945 \
      --press 665c54 \
      --press-sp d79921 \
      --text ebdbb2 \
      --text-sp fabd2f \
      --fn "CaskaydiaCove Nerd Font 16"
  '';

  oskAutoPython = pkgs.python3.withPackages (ps: with ps; [ pywayland ]);

  osk-autod = pkgs.writeScriptBin "osk-autod" ''
    #!${oskAutoPython}/bin/python3
    import subprocess
    from pywayland.client import Display
    from pywayland.protocol.input_method_unstable_v2 import ZwpInputMethodManagerV2

    def send_sig(sig):
        subprocess.run(["${pkgs.procps}/bin/pkill", f"-{sig}", "-x", "wvkbd-mobintl"], check=False)

    display = Display()
    display.connect()
    registry = display.get_registry()

    seat = None
    im_manager = None

    def handle_global(reg, name, interface, version):
        global seat, im_manager
        if interface == "wl_seat":
            seat = reg.bind(name, interface, min(version, 7))
        elif interface == "zwp_input_method_manager_v2":
            im_manager = reg.bind(name, interface, 1)

    registry.dispatcher["global"] = handle_global
    display.roundtrip()

    if seat and im_manager:
        im = im_manager.get_input_method(seat)
        im.dispatcher["activate"] = lambda _: send_sig("USR2")
        im.dispatcher["deactivate"] = lambda _: send_sig("USR1")
        while display.dispatch(block=True) != -1:
            pass
  '';

  toggle-osk = pkgs.writeShellScriptBin "toggle-osk" ''
    if ${pkgs.procps}/bin/pgrep -x wvkbd-mobintl >/dev/null; then
      ${pkgs.procps}/bin/pkill -RTMIN wvkbd-mobintl
    else
      ${wvkbdCmd}
    fi
  '';

  start-touch-gestures = pkgs.writeShellScriptBin "start-touch-gestures" ''
    TOUCH_DEV=""
    for dev in /dev/input/event*; do
      if ${pkgs.systemd}/bin/udevadm info -q property -n "$dev" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "^ID_INPUT_TOUCHSCREEN=1$"; then
        TOUCH_DEV="$dev"
        break
      fi
    done
    if [ -n "$TOUCH_DEV" ]; then
      exec ${pkgs.lisgd}/bin/lisgd -d "$TOUCH_DEV" \
        -t 220 \
        -m 800 \
        -r 20 \
        -g "1,DU,B,*,R,${toggle-osk}/bin/toggle-osk" \
        -g "3,LR,*,*,R,${pkgs.sway}/bin/swaymsg workspace prev" \
        -g "3,RL,*,*,R,${pkgs.sway}/bin/swaymsg workspace next" \
        -g "3,UD,*,*,R,${pkgs.sway}/bin/swaymsg floating toggle" \
        -g "3,DU,*,*,R,${pkgs.sway}/bin/swaymsg exec rofi -show drun"
    fi
    exit 1
  '';

  on-tablet-mode = pkgs.writeShellScriptBin "on-tablet-mode" ''
    ${pkgs.sway}/bin/swaymsg input type:touchpad events disabled
    if ! ${pkgs.procps}/bin/pgrep -x rot8 >/dev/null; then
      ${pkgs.rot8}/bin/rot8 &
    fi
    ${pkgs.eww}/bin/eww open tablet-dock
  '';

  off-tablet-mode = pkgs.writeShellScriptBin "off-tablet-mode" ''
    ${pkgs.sway}/bin/swaymsg input type:touchpad events enabled
    ${pkgs.sway}/bin/swaymsg input type:keyboard events enabled
    ${pkgs.procps}/bin/pkill -x rot8 || true
    ${pkgs.procps}/bin/pkill -f osk-autod || true
    ${pkgs.procps}/bin/pkill -x wvkbd-mobintl || true
    ${pkgs.eww}/bin/eww close tablet-dock || true
    ${pkgs.sway}/bin/swaymsg output eDP-1 transform normal
  '';
in
{
  inherit
    toggle-osk
    on-tablet-mode
    off-tablet-mode
    start-touch-gestures
    ;

  packages = with pkgs; [
    eww
    wvkbd
    osk-autod
    rot8
    lisgd
    libinput
    toggle-osk
    on-tablet-mode
    off-tablet-mode
    start-touch-gestures
  ];
}
