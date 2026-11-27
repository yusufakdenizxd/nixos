{ pkgs, ... }:

let
  fuzzel-clip = pkgs.writeShellScriptBin "fuzzel-clip" ''
    ${pkgs.cliphist}/bin/cliphist list \
      | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Clipboard: " --width=60 \
      | ${pkgs.cliphist}/bin/cliphist decode \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  fuzzel-calc = pkgs.writeShellScriptBin "fuzzel-calc" ''
    expr=$(${pkgs.fuzzel}/bin/fuzzel --dmenu --lines=0 --prompt="Calc: ")
    [ -z "$expr" ] && exit 0
    result=$(${pkgs.libqalculate}/bin/qalc -t "$expr")
    choice=$(printf "%s\n%s = %s" "$result" "$expr" "$result" \
      | ${pkgs.fuzzel}/bin/fuzzel --dmenu --lines=2 --prompt="Copy: ")
    [ -n "$choice" ] && printf "%s" "$result" | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  fuzzel-files = pkgs.writeShellScriptBin "fuzzel-files" ''
    file=$(${pkgs.fd}/bin/fd --type f \
      --exclude .git \
      --exclude .local \
      --exclude .cache \
      --exclude .mozilla \
      --exclude .thunderbird \
      --exclude .cargo \
      --exclude .rustup \
      --exclude .nix-profile \
      --exclude .nix-defexpr \
      --exclude go \
      --exclude node_modules \
      --exclude target \
      . "$HOME" \
      | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Files: " --width=70)
    [ -n "$file" ] && ${pkgs.xdg-utils}/bin/xdg-open "$file"
  '';

  fuzzel-emoji = pkgs.writeShellScriptBin "fuzzel-emoji" ''
    BEMOJI_PICKER_CMD="${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt='Emoji: '" \
      ${pkgs.bemoji}/bin/bemoji -t
  '';
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.ghostty}/bin/ghostty -e";
        font = "CaskaydiaCove Nerd Font:size=10";
        icon-theme = "Papirus-Dark";
        icons-enabled = true;
        fuzzy = true;
        sort-result = true;
        match-counter = true;
        lines = 12;
        width = 45;
        horizontal-pad = 20;
        vertical-pad = 14;
        inner-pad = 8;
        exit-on-keyboard-focus-loss = true;
      };

      colors = {
        background = "1d2021f2";
        text = "ebdbb2ff";
        prompt = "b8bb26ff";
        placeholder = "928374ff";
        input = "ebdbb2ff";
        match = "fabd2fff";
        selection = "3c3836ff";
        selection-text = "fbf1c7ff";
        selection-match = "fe8019ff";
        counter = "83a598ff";
        border = "d79921ff";
      };

      border = {
        width = 2;
        radius = 8;
      };

      key-bindings = {
        next = "Down Control+j";
        prev = "Up Control+k";
        execute = "Return";
        cancel = "Escape Control+g Control+bracketleft";
        delete-line-forward = "none";
      };
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
    bemoji
    fuzzel-clip
    fuzzel-calc
    fuzzel-files
    fuzzel-emoji
  ];
}
