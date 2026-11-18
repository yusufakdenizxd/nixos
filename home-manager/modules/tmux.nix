{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushell}/bin/nu";
    terminal = "tmux-256color";
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*:Tc"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -as terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      setw -g xterm-keys on
      set -g extended-keys on
      set -sag terminal-features 'xterm*:extkeys'

      set-option -gq allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      unbind C-b
      bind-key C-a send-prefix

      bind r source-file ~/.config/tmux/tmux.conf

      set-option -g renumber-windows on
      setw -g pane-base-index 1

      unbind-key -T copy-mode-vi v
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection

      bind-key v split-window -h
      bind-key s split-window -v

      bind-key C-d new-window -n 'lazydocker' 'lazydocker'
      bind-key D new-window -n 'lazydocker' 'lazydocker'

      bind X confirm-before -p "kill session? (y/n)" kill-session

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key - switch-client -p
      bind-key = switch-client -n

      bind -n M-h resize-pane -L 5
      bind -n M-l resize-pane -R 5
      bind -n M-j resize-pane -D 5
      bind -n M-k resize-pane -U 5

      set-option -wg automatic-rename on
      set-option -g status-position bottom
      set -g detach-on-destroy off
      set-option -g exit-empty off

      bind-key t run-shell "/home/akdeniz/dev/tmux_sessionizer/tmux-sessionizer.sh"
      bind-key T run-shell "/home/akdeniz/dev/dot-config/zsh/script/create_dir.sh"
      bind-key C run-shell "/home/akdeniz/dev/dot-config/zsh/script/clone_dir.sh"

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

      set-hook -g after-copy-mode 'set -p cursor-style block'

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

      set -g status-style fg=default,bg=default
      set -g status-left "#S "
      set -g status-left-length 100
      set -g status-right-length 100
      set -g message-style bg=default,fg=white
      set -g message-command-style bg=default,fg=white
      set -g status-justify left
      set -g window-status-format "#{window_index}:#{window_name}#{window_flags} "
      set -g window-status-current-format "#{window_index}:#{window_name}#{window_flags} "
      set -g window-status-current-style "fg=#e1a345"
      set -g window-status-last-style "fg=#936a2e"
      set -g status-right "#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)"
    '';
  };
}
