{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunar
    thunar-volman
    thunar-archive-plugin
    tumbler
    file-roller
    gvfs
    ffmpegthumbnailer
    gruvbox-gtk-theme
  ];

  home.file.".local/share/applications/thunar.desktop".text = ''
    [Desktop Entry]
    Name=Files
    Comment=Browse the filesystem with the file manager
    GenericName=File Manager
    Exec=thunar %F
    Icon=org.xfce.thunar
    Terminal=false
    StartupNotify=true
    Type=Application
    Categories=System;Utility;Core;GTK;FileManager;
    MimeType=inode/directory;
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Gruvbox-Dark";
      icon-theme = "Papirus-Dark";
      enable-animations = false;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
