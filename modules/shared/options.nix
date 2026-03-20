{ lib, ... }: {
  options = {
    _3dPrinting.enable = lib.mkEnableOption "Enable 3D printing support";
  };
}
