{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    granted
  ];

  home.file.".aws/cli/alias".text = ''
    [toplevel]

    whoami = sts get-caller-identity
  '';

  programs.zsh.shellAliases = {
    assume = "source assume";
    asr = "assume $(aws configure list-profiles | fzf)";
    asc = "assume $(aws configure list-profiles | fzf) -c";
    ast = "assume $(aws configure list-profiles | fzf) -t";
  };
}
