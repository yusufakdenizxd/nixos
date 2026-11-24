{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = true;

    settings = {
      theme = "Gruvbox Dark Hard";
      window-decoration = false;
      mouse-hide-while-typing = true;
      background-opacity = 0.90;

      font-family = "CaskaydiaCove Nerd Font Mono";
      font-thicken = true;
      font-size = 14;

      cursor-style = "bar";
      cursor-style-blink = false;

      command = "${pkgs.tmux}/bin/tmux new-session -A -D -s dev -c /home/akdeniz/dev";

      keybind = [
        "super+f=text:\\x01f"
        "super+v=paste_from_clipboard"
        "super+shift+,=reload_config"

        "super+a=text:\\x01c"
        "super+z=text:\\x01z"
        "super+x=text:\\x01x"

        "super+|=decrease_font_size:1"
        "super+\\=increase_font_size:1"

        "super+shift+x=text:\\x01X"
        "super+shift+g=text:\\x01G"
        "super+shift+d=text:\\x01D"
        "super+w=text:\\x01w"
        "super+;=text:\\x01:"
        "super+,=text:\\x01,"
        "super+n=text:\\x01t"
        "super+shift+n=text:\\x01T"
        "super+shift+c=text:\\x01C"

        "super+p=text:\\x01["
        "super+[=text:\\x01p"
        "super+]=text:\\x01n"

        "super+shift+[=text:\\x01-"
        "super+shift+]=text:\\x01="

        "super+b=text:\\x01v"
        "super+g=text:\\x01s"

        "super+1=text:\\x011"
        "super+2=text:\\x012"
        "super+3=text:\\x013"
        "super+4=text:\\x014"
        "super+5=text:\\x015"
        "super+6=text:\\x016"
        "super+7=text:\\x017"
        "super+8=text:\\x018"
        "super+9=text:\\x019"

        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+backspace=text:\\x17"
      ];
    };
  };
}
