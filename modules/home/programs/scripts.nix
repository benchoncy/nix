{ lib, ... }: {
  home.file = {
    ".local/scripts/tmux-sessionizer" = {
      source = ./scripts/tmux-sessionizer.sh;
      executable = true;
    };
    ".local/scripts/tmux-windowizer" = {
      source = ./scripts/tmux-windowizer.sh;
      executable = true;
    };
    ".local/scripts/git-afforester" = {
      source = ./scripts/git-afforester.py;
      executable = true;
    };
  };
}
