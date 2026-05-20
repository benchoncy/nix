{ lib, pkgs, ... }:
let
  shellConfigRoot = ./config/shell;

  collectShellEntries = dir: relPath:
    lib.flatten (lib.mapAttrsToList
      (name: type:
        let
          sourcePath = dir + "/${name}";
          nextRelPath = if relPath == "" then name else "${relPath}/${name}";
        in
        if type == "directory" then
          collectShellEntries sourcePath nextRelPath
        else
          [
            (lib.nameValuePair ".config/shell/${nextRelPath}" {
              source = sourcePath;
            })
          ])
      (builtins.readDir dir));

  defaultShellFiles = lib.listToAttrs (collectShellEntries shellConfigRoot "");
in {
  config.home.file = {
    ".zshrc".source = ./config/.zshrc;
    ".bashrc".source = ./config/.bashrc;
    ".config/starship.toml".source = ./config/starship.toml;
    ".zsh/zsh-autosuggestions" = {
      source = "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
      recursive = true;
    };
  } // defaultShellFiles;
}
