{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
      yank
      vim-tmux-navigator
      catppuccin
    ];
    extraConfig = builtins.readFile ./config/tmux.conf;
  };

  home.file.".local/scripts/tmux-sessionizer" = {
    source = ./scripts/tmux-sessionizer.sh;
    executable = true;
  };

  home.file.".local/scripts/tmux-windowizer" = {
    source = ./scripts/tmux-windowizer.sh;
    executable = true;
  };

  home.file.".config/shell/tools/tmux.sh".text = ''
    alias t="tmux"
    alias ta="tmux attach"
    alias tn="tmux new-session -A -s"
    alias td="tmux detach-client"
    alias tl="tmux list-sessions"
    alias tkill="tmux kill-session -t"
    alias ts="tmux-sessionizer"
    alias tw="tmux-windowizer"
  '';
}
