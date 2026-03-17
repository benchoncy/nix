{ lib, config, inputs, username, ... }:
let
  workModulePath = if config.my.work.repoPath == null then null else "${config.my.work.repoPath}/modules/home/default.nix";
in {
  home-manager = {
    users."${username}".imports = [
      ../home 
      ({ osConfig, ... }: {
        my.work.enable = osConfig.my.work.enable or false;
        my.work.repoPath = osConfig.my.work.repoPath or null;
      })
      inputs.catppuccin.homeModules.catppuccin
    ] ++ lib.optional (config.my.work.enable && workModulePath != null && builtins.pathExists workModulePath) workModulePath;

    backupFileExtension = "bkp";
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs username;
    };
  };
}
