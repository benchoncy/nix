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
    extraConfig = builtins.readFile ../../../home-files/common/.config/tmux/tmux.conf;
  };
}
