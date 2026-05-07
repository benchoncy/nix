# Work Overlay MVP

This is a generic example of the minimum private work wrapper flake expected to compose with the shared repo.

## Breaking Changes (2025-05)

This example was updated for the new Home Manager profile system. Key changes:

- `homeProfiles.ai.*` - AI tooling and policy (all options under homeProfiles.ai)
- `homeProfiles.developer.enable` - enables developer profile (includes bruno by default)
- `homeProfiles.developer.github.enable` - enables gh CLI and gh-dash (replaces `github.tooling.enable`)
- `homeProfiles.developer.opencode.enable` - enables opencode program + config
- `homeProfiles.developer.aws.enable` - enables awscli2

Suggested layout:

- `flake.nix`
- `Makefile`
- `modules/home/default.nix`
- `modules/home/aws/config/cli/alias` (work AWS config)
- `modules/home/shell/tools/work-ticket.sh` (work shell tools)
- `hosts/darwin-work/configuration.nix`

Customize these placeholders before using it:

- `<work-email>`
- `<work-git-host>`
- `<work-domain>`
- the AWS profiles in `modules/home/aws/config/cli/alias`
- any ticketing CLI commands in `modules/home/shell/tools/work-ticket.sh`

The example `modules/home/default.nix` also shows how to layer work-only OpenCode MCP servers on top of the shared baseline with `opencode.mcp.<name>`.
It also demonstrates the recommended `gh-dash` machine default host setup for mixed public/work GitHub usage.

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
