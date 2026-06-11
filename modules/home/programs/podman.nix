{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    podman
    podman-desktop
  ];

  launchd.agents.podman-machine = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-lc"
        ''
          state="$(${pkgs.podman}/bin/podman machine inspect podman-machine-default --format '{{.State}}' 2>/dev/null || true)"

          if [ "$state" != "running" ]; then
            exec ${pkgs.podman}/bin/podman machine start --no-info podman-machine-default
          fi
        ''
      ];
      RunAtLoad = true;
    };
  };
}
