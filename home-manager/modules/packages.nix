{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wofi
    swaybg
    wifitui
    wev
    openvpn

    tree-sitter

    (pkgs.symlinkJoin {
      name = "krita-wayland-fix";
      paths = [ pkgs.krita ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/krita \
          --set QT_QPA_PLATFORM wayland \
          --set QT_ENABLE_HIGHDPI_SCALING 0
      '';
    })

    mgba

    rnote
    xournalpp
    foliate

    discord
    thunderbird

    networkmanager_dmenu
    bzmenu
    overskride

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
