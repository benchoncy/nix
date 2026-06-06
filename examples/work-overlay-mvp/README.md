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

The example `modules/home/default.nix` also shows how to layer work-only OpenCode MCP servers on top of the shared baseline with `programs.opencode.settings.mcp.<name>`.
It also demonstrates the recommended `github.ghDash.host` customization for mixed public/work GitHub usage; GitHub tooling is still enabled by `homeProfiles.developer.github.enable`.

## OpenCode Overrides

Use two layers for OpenCode in the wrapper:

- shared prompts, commands, and skills stay in the shared repo under `modules/home/programs/opencode/config/`
- wrapper-local or machine-local JSON overrides go through `programs.opencode.settings`

Because `modules/home/default.nix` is a Home Manager module, it can set `programs.opencode.*` directly:

```nix
programs.opencode.settings.agent."pr-review-orchestrator".model = "openai/gpt-5";
```

If a single embedded host needs a different override, set the Home Manager option from the host under `home-manager.users.${username}`:

```nix
home-manager.users.${username}.programs.opencode.settings.agent."pr-review-orchestrator".model = "openai/gpt-5";
```

Keep prompts in markdown agent files. If a field needs to vary by machine, leave it out of the shared markdown agent definition and set it from JSON instead.

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
