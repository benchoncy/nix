{ lib, config, ... }:
let
  workModulePath = if config.my.work.repoPath == null then null else "${config.my.work.repoPath}/modules/home/default.nix";
in {
  assertions = [
    {
      assertion = !config.my.work.enable || (workModulePath != null && builtins.pathExists workModulePath);
      message = "Work configuration is enabled but no private work module exists at ${toString workModulePath}.";
    }
  ];
}
