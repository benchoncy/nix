{ ... }: {
  # Configure video drivers
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";
}
