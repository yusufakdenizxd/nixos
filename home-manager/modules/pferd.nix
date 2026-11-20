{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pferd
  ];

  xdg.configFile."PFERD/pferd.cfg".text = ''
    [DEFAULT]
    working_dir = ~/uni

    [auth:ilias]
    type = pass
    passname = kit/ilias

    [crawl:ilias]
    type = kit-ilias-web
    auth = auth:ilias
    target = desktop
    output_dir = .
    on_conflict = local-first

    transform =
        "*Description.html" --> !

        "**/Tutoriumsblätter**" --> {0}
        "**/Tutoriumstermine*" --> {0}
        "**/Maximilian Kirchhof**" --> {0}
        "**/Hannes Hagenberger**" --> {0}
        "**/Merlin Greve**" --> {0}
        # "**/Leonard Schaffert**" --> {0}

        "**/Tutorien/**" --> !
        "**/Tutorium/**" --> !
        "**/Tutoriumsmaterial/**" --> !
  '';
}
