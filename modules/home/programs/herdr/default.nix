{ inputs, pkgs, ... }:
let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  home.packages = [ unstablePkgs.herdr ];

  home.file.".config/herdr/config.toml".text = ''
    [keys]
    prefix = "ctrl+a"
  '';

  home.file.".local/scripts/herdr-workspace" = {
    source = ./scripts/herdr-workspace.sh;
    executable = true;
  };

  programs.zsh.shellAliases = {
    h = "herdr";
    hw = "herdr-workspace";
  };
}
