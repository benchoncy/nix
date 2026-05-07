{ lib, ... }: {
  home.file = {
    ".local/scripts/tmux-sessionizer" = {
      source = ./tmux-sessionizer.sh;
      executable = true;
    };
    ".local/scripts/tmux-windowizer" = {
      source = ./tmux-windowizer.sh;
      executable = true;
    };
    ".local/scripts/git-afforester" = {
      source = ./git-afforester.py;
      executable = true;
    };
  };
}