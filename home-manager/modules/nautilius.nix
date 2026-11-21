{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    sushi
    gvfs
    ffmpegthumbnailer
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
    "org/gnome/nautilus/preferences" = {
      search-filter-time-type = "last_modified";
    };
    "org/freedesktop/tracker/miner/files" = {
      crawling-interval = -2;
      enable-monitors = false;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
