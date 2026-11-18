{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wofi
    swaybg
    wifitui
    wev
    openvpn

    tree-sitter

    mgba

    rnote
    xournalpp
    foliate

    discord
    thunderbird

    networkmanager_dmenu
    bzmenu
    overskride

    lazygit
    gnumake
    gcc
    fzf
    ripgrep
    fd
    bat
    eza
    zoxide
    lua5_1
    luarocks

    btop
    nodejs
    python3
    python3Packages.pip
    rustup
    go

    unzip
    gnutar
    gzip

    jdk25
    maven
    gradle
    (prismlauncher.override {
      jdks = [
        jdk25
        jdk21
      ];
    })
  ];
}
