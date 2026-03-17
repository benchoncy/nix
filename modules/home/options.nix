{ lib, ... }: {
  options.my.work = {
    enable = lib.mkEnableOption "Enable work-specific Home Manager configuration";
    repoPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute path to the local private work Home Manager repo.";
    };
  };
}
