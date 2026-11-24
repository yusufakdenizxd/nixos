{ pkgs, ... }:

let
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    pkill -x rofi || ${pkgs.cliphist}/bin/cliphist list | \
      ${pkgs.rofi}/bin/rofi -dmenu -p "Clipboard" -display-columns 2 | \
      ${pkgs.cliphist}/bin/cliphist decode | \
      ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  rofi-files = pkgs.writeShellScriptBin "rofi-files" ''
    HIST_FILE="$HOME/.cache/rofi-files.hist"
    touch "$HIST_FILE"

    selected=$(
      {
        ${pkgs.gawk}/bin/awk '{count[$0]++} END {for (line in count) print count[line] "\t" line}' "$HIST_FILE" | \
          sort -rn | cut -f2-
        ${pkgs.fd}/bin/fd --type f \
          --exclude .git \
          --exclude node_modules \
          --exclude target \
          --exclude .cache \
          --exclude .local \
          --exclude .cargo \
          --exclude .rustup \
          --exclude go \
          --exclude .mozilla \
          --exclude .npm \
          --exclude .direnv \
          --exclude .venv \
          --exclude __pycache__ \
          --exclude result \
          . /home/akdeniz | sed "s|^/home/akdeniz/||"
      } | ${pkgs.gawk}/bin/awk '!seen[$0]++' | \
        ${pkgs.rofi}/bin/rofi -dmenu -i -p "Files" -matching fuzzy -sorting-method fzf
    )

    if [ -n "$selected" ]; then
      full_path="/home/akdeniz/$selected"
      if [ -f "$full_path" ]; then
        echo "$selected" >> "$HIST_FILE"
        tail -n 500 "$HIST_FILE" > "$HIST_FILE.tmp" && mv "$HIST_FILE.tmp" "$HIST_FILE"
        nohup ${pkgs.xdg-utils}/bin/xdg-open "$full_path" >/dev/null 2>&1 &
      fi
    fi
  '';
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    font = "JetBrainsMono Nerd Font 14";
    theme = "gruvbox-dark-hard";

    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];

    extraConfig = {
      modi = "drun";

      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "Apps";
      display-window = "Windows";
      drun-display-format = "{name}";

      disable-history = false;
      max-history-size = 50;
      drun-use-desktop-cache = false;
      drun-reload-desktop-cache = true;
      lazy-grab = true;

      hide-scrollbar = true;
      sidebar-mode = false;

      click-to-exit = true;
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";

      kb-row-down = "Down,Control+n,Control+j";
      kb-row-up = "Up,Control+p,Control+k";
      kb-accept-entry = "Return,KP_Enter";
      kb-remove-to-eol = "";
      kb-mode-next = "Shift+Right,Control+Tab";
      kb-mode-previous = "Shift+Left,Control+ISO_Left_Tab";
      kb-cancel = "Escape,Control+g,Control+bracketleft";

      calc-command = "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy";
    };
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    wl-clipboard
    cliphist
    fd
    gawk
    libqalculate
    rofi-clipboard
    rofi-files
  ];
}
