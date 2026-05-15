{ lib, ... }:
let
  shellConfigRoot = ./shell/config/shell;

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
    ".zshrc".source = ./shell/config/.zshrc;
    ".bashrc".source = ./shell/config/.bashrc;
    ".config/starship.toml".source = ./shell/config/starship.toml;
  } // defaultShellFiles;
}
