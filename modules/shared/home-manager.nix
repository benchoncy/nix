{ inputs, username, ... }: {
  home-manager = {
    users."${username}".imports = [
      ../home 
      inputs.catppuccin.homeModules.catppuccin
    ];

    backupFileExtension = "bkp";
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit username;
    };
  };
}
