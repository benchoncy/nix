{ config, pkgs, lib, ... }:
let
  signingProgram = if pkgs.stdenv.isDarwin then
    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
  else
    "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in {
  home.packages = with pkgs; [ diffnav ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
      line-numbers-left-style = "#8AADF4";
      line-numbers-right-style = "#8AADF4";
      line-numbers-minus-style = "#EE99A0";
      line-numbers-plus-style = "#A6DA95";
      line-numbers-zero-style = "#6E738D";
      syntax-theme = "Catppuccin Macchiato";
      plus-style = "syntax #1E2030";
      plus-emph-style = "syntax bold #294436";
      minus-style = "syntax #1E2030";
      minus-emph-style = "syntax bold #4B2C3A";
      hunk-header-style = "syntax #8AADF4";
      hunk-header-decoration-style = "#494D64 ul";
      file-style = "bold #CAD3F5";
      file-decoration-style = "#8AADF4";
      commit-style = "bold #C6A0F6";
      commit-decoration-style = "#C6A0F6";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ben Stuart";
        email = "ben@benstuart.ie";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWgRvHskkugDphe4+YPRUe3ztq0cOYV9hDlYMG7+roi";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
        excludesfile = "${config.xdg.configHome}/git/ignore";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSign = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = signingProgram;
      alias = {
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
        af = "!git-afforester";
        diffnav = "!f() { git diff \"$@\" | diffnav; }; f";
      };
    };
  };

  xdg.configFile."git/ignore".text = ''
    .ansible/
  '';

  home.file."${config.xdg.configHome}/diffnav/config.yml".source = ./config/diffnav/config.yml;

  home.file.".local/scripts/git-afforester" = {
    source = ./scripts/git-afforester.py;
    executable = true;
  };

  programs.zsh.shellAliases = {
    g = "git";
    gp = "git pull && git push";
    gs = "git status";
    ga = "git add";
    gaa = "git add .";
    gc = "git commit";
    gac = "git commit -a";
  };

  programs.zsh.initContent = ''
    gaf() {
      if [[ $# -eq 0 ]]; then
        command git-afforester
        return $?
      fi

      if [[ "$1" == "switch" || "$1" == "-s" || "$1" == "--switch" ]]; then
        shift
        local target_path
        if ! target_path=$(command git-afforester worktree resolve "$@"); then
          return $?
        fi
        if [[ -z $target_path ]]; then
          return 0
        fi
        cd "$target_path" || return
        return 0
      fi

      if [[ "$1" == "worktree" && "$2" == "create" ]]; then
        shift 2
        local switch_after_create=0
        local create_args=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -s|--switch)
              switch_after_create=1
              ;;
            *)
              create_args+=("$1")
              ;;
          esac
          shift
        done

        local created_path
        if ! created_path=$(command git-afforester worktree create "''${create_args[@]}"); then
          return $?
        fi

        if [[ $switch_after_create -eq 1 ]]; then
          if [[ -z $created_path ]]; then
            return 0
          fi

          local created_project
          local created_name
          created_project=$(dirname "$created_path")
          created_name=$(basename "$created_path")

          local resolved_path
          if ! resolved_path=$(command git-afforester worktree --project "$created_project" resolve "$created_name"); then
            return $?
          fi
          if [[ -z $resolved_path ]]; then
            return 0
          fi

          cd "$resolved_path" || return
          return 0
        fi

        if [[ -n $created_path ]]; then
          printf '%s\n' "$created_path"
        fi
        return 0
      fi

      command git-afforester "$@"
    }

    gafn() {
      gaf worktree create "$@"
    }
  '';
}
