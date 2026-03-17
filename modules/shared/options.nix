{ lib, ... }: {
  options = {
    _3dPrinting.enable = lib.mkEnableOption "Enable 3D printing support";
    my.work.enable = lib.mkEnableOption "Enable work-specific configuration";
    my.work.repoPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute path to the local private work Home Manager repo.";
    };
  };
}
