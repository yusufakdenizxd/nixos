{ config, pkgs, ... }:

let
  suwayomi-latest = pkgs.suwayomi-server.overrideAttrs (oldAttrs: rec {
    version = "2.4.2490";
    src = pkgs.fetchurl {
      url = "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/v${version}/Suwayomi-Server-v${version}.jar";
      hash = "sha256-gl4AIZu6yBaiQFu13q+aswS4ZLf6/QOx+2L3cn/5w14=";
    };
  });

  manga = pkgs.writeShellScriptBin "manga" ''
    ${suwayomi-latest}/bin/tachidesk-server \
      -Djava.net.preferIPv4Stack=true \
      -Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false \
      -Dsuwayomi.tachidesk.config.server.defaultUserAgent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" \
      >/tmp/suwayomi.log 2>&1 &
    SERVER_PID=$!
    trap "kill $SERVER_PID 2>/dev/null" EXIT

    for i in $(seq 1 40); do
      if ${pkgs.curl}/bin/curl -sf http://127.0.0.1:4567/api/v1/settings/about >/dev/null; then
        break
      fi
      sleep 0.5
    done

    brave --user-data-dir="$HOME/.local/share/kaori-webapp" --ozone-platform-hint=auto --app=http://127.0.0.1:4567 --new-window >/dev/null 2>&1
  '';
in
{
  home.packages = with pkgs; [
    suwayomi-latest
    manga
  ];

  xdg.desktopEntries.manga = {
    name = "Manga";
    genericName = "Manga Reader";
    exec = "manga";
    icon = "accessories-dictionary";
    terminal = false;
    categories = [
      "Application"
      "Graphics"
      "Viewer"
    ];
  };
}
