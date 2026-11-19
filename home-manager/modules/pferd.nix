{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pferd
  ];

  xdg.configFile."PFERD/pferd.cfg".text = ''
    [DEFAULT]
    working_dir = ~/uni/kit

    [auth:ilias]
    type = pass
    passname = kit/ilias

    [crawl:ilias]
    type = kit-ilias-web
    auth = auth:ilias
    target = desktop
    output_dir = .
    on_conflict = local-first
  '';
}
