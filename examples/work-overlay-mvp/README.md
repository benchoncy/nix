# Wrapper Flake Template

This is a realistic, organization-neutral wrapper flake template composed with
the shared repository as a Git submodule. It is suitable as a starting point
for a private machine configuration and is also used by
`scripts/bootstrap-wrapper.sh`.

The bootstrap command creates this layout directly at `~/.nix-config`:

```sh
curl -fsSL https://raw.githubusercontent.com/benchoncy/nix/main/scripts/bootstrap-wrapper.sh | sh
```

Pass a first argument to test elsewhere:

```sh
curl -fsSL https://raw.githubusercontent.com/benchoncy/nix/main/scripts/bootstrap-wrapper.sh \
  | sh -s -- /tmp/nix-config-test
```

## Breaking Changes (2025-05)

This example was updated for the new Home Manager profile system. Key changes:

- `homeProfiles.ai.*` - AI tooling and policy (all options under homeProfiles.ai)
- `homeProfiles.developer.enable` - enables developer profile (includes bruno by default)
- `homeProfiles.developer.github.enable` - enables gh CLI and gh-dash (replaces `github.tooling.enable`)
- `homeProfiles.developer.opencode.enable` - enables opencode program + config
- `homeProfiles.developer.aws.enable` - enables awscli2

The generated wrapper contains:

- `flake.nix`
- `Makefile`
- `modules/home/default.nix`
- `modules/home/aws/config/cli/alias` (work AWS config)
- `modules/home/shell/tools/work-ticket.sh` (work shell tools)
- `hosts/darwin-work/configuration.nix`
- `hosts/nixos-work/configuration.nix`
- `shared/` (Git submodule added by the bootstrap script)

Customize these placeholders before using it:

- `<work-email>`
- `<work-git-host>`
- the AWS profiles in `modules/home/aws/config/cli/alias`
- any ticketing CLI commands in `modules/home/shell/tools/work-ticket.sh`

The flake exposes Darwin, NixOS, and standalone Home Manager outputs. The
standalone Home Manager output sets its username, home directory, and state
version explicitly so it can be used without a system module. The system
outputs use the shared `darwinModules.base` and `nixosModules.base` exports,
while the standalone output uses `homeModules.base`.

The example `modules/home/default.nix` also shows how to layer work-only OpenCode MCP servers on top of the shared baseline with `programs.opencode.settings.mcp.<name>`.
It also demonstrates the recommended `github.ghDash.host` customization for mixed public/work GitHub usage; GitHub tooling is still enabled by `homeProfiles.developer.github.enable`.

## OpenCode Overrides

Use two layers for OpenCode in the wrapper:

- shared prompts, commands, skills, and plugins stay in the shared repo under `modules/home/programs/opencode/config/`
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

Before using the template:

- replace the identity and host placeholders
- replace the example work email, Git host, AWS profiles, and MCP endpoint
- add only the private files and secrets needed by the target machine

The wrapper flake should:

- keep the shared repo as the local `shared` submodule input
- own its `nixpkgs` pin and wire shared to follow it
- own the final work-machine outputs
- compose from `darwinModules.base`, `nixosModules.base`, and `homeModules.base`

Useful commands:

- `make check`
- `make update`
- `make update-shared`
- `make update-nixpkgs`

The bootstrap script initializes the repository and submodule but does not
create a commit or configure a remote. Review the generated files, then commit
them and add the private wrapper remote yourself.
