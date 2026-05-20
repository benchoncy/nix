{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    granted
  ];

  home.file.".aws/cli/alias".text = ''
    [toplevel]

    whoami = sts get-caller-identity
  '';

  home.file.".config/shell/tools/aws.sh".text = ''
    # Granted.dev assume
    alias assume="source assume"
    alias asr='assume $(aws configure list-profiles | fzf)'    # [as]sume [r]ole
    alias asc='assume $(aws configure list-profiles | fzf) -c' # [as]sume [c]onsole
    alias ast='assume $(aws configure list-profiles | fzf) -t' # [as]sume [t]erminal
  '';
}
