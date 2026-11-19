{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      keybinding = {
        universal = {
          jumpToBlock = [
            ""
            "1"
            "2"
            "3"
            "4"
          ];
        };
      };
    };
  };
}
