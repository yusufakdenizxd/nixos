{
  config,
  pkgs,
  lib,
  ...
}:

let
  moduleFiles = builtins.readDir ./modules;
  autoImports = lib.mapAttrsToList (name: _: ./modules/${name}) (
    lib.filterAttrs (
      name: type:
      (type == "regular" && lib.hasSuffix ".nix" name)
      || (type == "directory" && builtins.pathExists ./modules/${name}/default.nix)
    ) moduleFiles
  );
in
{
  imports = autoImports;

  home.username = "akdeniz";
  home.homeDirectory = "/home/akdeniz";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Yusuf Akdeniz";
        email = "yusufakdenizxd@gmail.com";
      };
      init.defaultBranch = "master";
      pull.rebase = true;
    };
  };

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi -dmenu -i -p "Wi-Fi"
    rofi_highlight = True
    compact = True
    wifi_chars = ▂▄▆█

    [pinentry]
    description = Wi-Fi Şifresi
    prompt = Şifre:
  '';

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    NIXOS_OZONE_WL = "1";
    JAVA_HOME = "${pkgs.jdk25}";
    GOPATH = "$HOME/go";
    NH_HOME_FLAKE = "/home/akdeniz/dev/nixos";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland;
  };
}
