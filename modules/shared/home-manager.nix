{ inputs, username, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    extraSpecialArgs = {
      inherit inputs username;
    };
    users.${username}.imports = [
      ../home/profiles/system.nix
      inputs.catppuccin.homeModules.catppuccin
    ];
  };
}
