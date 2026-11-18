{ pkgs, ... }:

let
  ntfyTopic = "akdenix-nixos-3152girenoc";

  notify = pkgs.writeShellScriptBin "notify" ''
    TITLE="NixOS"
    PRIORITY="low"

    while getopts "dut:" opt; do
      case "$opt" in
        d) PRIORITY="default" ;;
        u) PRIORITY="urgent" ;;
        t) TITLE="$OPTARG" ;;
        *) exit 1 ;;
      esac
    done
    shift $((OPTIND - 1))

    if [ $# -eq 0 ]; then
      echo "Kullanim: notify [-d | -u] [-t baslik] mesaj..."
      exit 1
    fi

    MESSAGE="$*"

    ${pkgs.curl}/bin/curl -fsS \
      -H "Title: $TITLE" \
      -H "Priority: $PRIORITY" \
      -d "$MESSAGE" \
      "https://ntfy.sh/${ntfyTopic}" >/dev/null
  '';
in
{
  home.packages = with pkgs; [
    notify
    libnotify
  ];

  services.fnott = {
    enable = true;
    settings = {
      main = {
        output = "eDP-1";
        anchor = "top-right";
        layer = "overlay";
        default-timeout = 3;
        background = "282828f2";
        border-color = "d79921ff";
        border-size = 2;
        border-radius = 10;
        padding-vertical = 14;
        padding-horizontal = 18;
        title-font = "CaskaydiaCove Nerd Font:size=13:weight=bold";
        title-color = "fabd2fff";
        summary-font = "CaskaydiaCove Nerd Font:size=12";
        summary-color = "ebdbb2ff";
        body-font = "CaskaydiaCove Nerd Font:size=12";
        body-color = "d5c4a1ff";
      };
    };
  };
}
