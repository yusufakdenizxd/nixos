{ ... }:

{
  programs.nushell = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      hm = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      fullcharge = "sudo tlp fullcharge BAT0";
      kit-vpn = "sudo openvpn --config ~/VPN/kit-split.ovpn";
    };

    environmentVariables = {
      NH_FLAKE = "/home/akdeniz/dev/nixos";
      NH_HOME_FLAKE = "/home/akdeniz/dev/nixos";
    };

    extraConfig = ''
      $env.config = {
        show_banner: false
        cursor_shape: {
          emacs: line
          vi_insert: line
          vi_normal: block
        }
      }
    '';
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      scan_timeout = 10;
      command_timeout = 200;

      format = "$directory$git_branch$git_status$character";

      directory = {
        style = "bold #98971a";
        truncation_length = 3;
        truncate_to_repo = false;
        home_symbol = "~";
      };

      git_branch = {
        symbol = " ";
        style = "bold #fabd2f";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold #fb4934";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      character = {
        success_symbol = "[❯](bold #83a598)";
        error_symbol = "[❯](bold #fb4934)";
        vimcmd_symbol = "[❮](bold #fabd2f)";
      };
    };
  };
}
