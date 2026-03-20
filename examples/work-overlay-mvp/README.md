# Work Overlay MVP

This is a generic example of the minimum private work wrapper flake expected to compose with the shared repo.

Suggested layout:

- `flake.nix`
- `Makefile`
- `modules/home/default.nix`
- `hosts/darwin-work/configuration.nix`
- `home-files/work/.aws/config`
- `home-files/work/.config/shell/tools/work-ticket.sh`

Customize these placeholders before using it:

- `<work-email>`
- `<work-git-host>`
- the AWS profiles in `home-files/work/.aws/config`
- any ticketing CLI commands in `work-ticket.sh`

The wrapper flake should:

- pull the shared repo as a normal flake input
- own its `nixpkgs` pin and wire shared to follow it
- own the final work-machine outputs
- compose from `darwinModules.base` and `homeModules.base`

Useful commands:

- `make check`
- `make update`
- `make update-shared`
- `make update-nixpkgs`
