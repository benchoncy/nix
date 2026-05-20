{ pkgs, ... }: {
  home.packages = with pkgs; [ nerd-fonts.hack ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    history.size = 10000;
    history.path = "$HOME/.zsh_history";

    shellAliases = {
      vim = "nvim";
      v = "nvim";
    };

    initContent = ''
      # 1Password SSH agent socket
      ${
        if pkgs.stdenv.isDarwin
        then ''export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
        else ''export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"''
      }

      # Load cached secrets if available
      if [[ -f "$HOME/.config/shell/secrets.env" ]]; then
        source "$HOME/.config/shell/secrets.env"
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration.disabled = true;

      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      directory = {
        read_only = " 󰌾";
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";
      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796"
      "--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6"
      "--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796"
      "--color=selected-bg:#494D64"
      "--color=border:#6E738D,label:#CAD3F5"
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    PATH = "$PATH:$HOME/.local/scripts:$HOME/.local/bin";
  };
}
