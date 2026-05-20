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

  programs.zsh.shellAliases = {
    t = "tmux";
    ta = "tmux attach";
    tn = "tmux new-session -A -s";
    td = "tmux detach-client";
    tl = "tmux list-sessions";
    tkill = "tmux kill-session -t";
    ts = "tmux-sessionizer";
    tw = "tmux-windowizer";
  };
}
