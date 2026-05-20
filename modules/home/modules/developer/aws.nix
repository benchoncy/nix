{ lib, osConfig, ... }: {
  imports = lib.optionals (osConfig.homeProfiles.developer.aws.enable or false) [
    ../../programs/aws
  ];
}
