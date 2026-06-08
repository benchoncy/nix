# Nix Configurations

This repository contains Nix configurations for target systems with the intent of creating a fully reproducible environment. The configuration aims to be used with NixOS or Nix on other Unix systems to produce my development environment across different machines.

# Usage

## NixOS

To use this configuration on NixOS, follow these steps:
1. Follow the [NixOS installation instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation) to install NixOS
2. Follow the [wiki instructions](https://nixos.wiki/wiki/Displaylink) to prefetch the DisplayLink non-free blob.
3. Run `make nixos-rebuild` to switch the default host (`NIXOS_HOST=nixos-bstuart`)
4. Override the target explicitly when needed: `make nixos-rebuild NIXOS_HOST=<flake-host>`

## MacOS (Darwin)

Generic macOS support lives in this repo, but final work-machine outputs are expected to be assembled in a separate private wrapper flake (for privacy).

To use this configuration for a work MacOS machine, follow these steps:
1. Follow the Determinate Systems [instructions](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) to install Nix
2. Clone or prepare the private work wrapper repo
3. Run `make darwin-rebuild` from the private work repo thereafter

# Development

## Testing Changes
Run `nix flake check` to test changes made to the flake before committing or initiating a rebuild.

Use `make update` to refresh this repo's flake inputs.

This shared repo only ships explicit rebuild targets for the outputs it defines:

- `make nixos-rebuild` → `sudo nixos-rebuild switch --flake .#$(NIXOS_HOST)`
- `make home-manager` → `home-manager switch --flake .#$(HOME_HOST)`

Darwin rebuilds should be run from a private wrapper flake that owns the final macOS host outputs.

## Home Manager Only

The flake exposes a standalone Home Manager output for the shared personal Linux dotfiles workflow.
Use `homeModules.base` for standalone Home Manager composition, and `homeModules.system` only through the embedded Home Manager system path.

For this repo, the exported standalone target is the personal `nixos-bstuart-home` output on `x86_64-linux`:

- `home-manager switch --flake .#nixos-bstuart-home`
- `make home-manager`

Work-only or macOS standalone Home Manager outputs are expected to live in the private wrapper flake, not this shared repo.

## Raw Dotfiles

The repo supports raw dotfile copying through program/module directories.

- Raw dotfiles are distributed to their respective program/module directories:
  - `programs/neovim/config/` - neovim configuration
  - `programs/shell/config/` - shell configuration (zshrc, bashrc, starship, shell tools)
  - `programs/scripts/` - user scripts (tmux-sessionizer, git-afforester, etc.)
  - `programs/git/config/diffnav/` - diffnav configuration
  - `programs/tmux/config/` - tmux configuration
  - `modules/home/programs/opencode/config/` - opencode agents, commands, skills, plugins
  - `modules/home/programs/github/scripts/` - github helper scripts
- prefer whole app directories under `.config/<app>` instead of one giant `.config` mapping
- keep reserved/generated files like `.gitconfig`, `.ssh/config`, `.aws/config`, `.config/ghostty/config`, and `.config/opencode/opencode.jsonc` in Home Manager modules rather than raw copies

## Home Manager Profiles

The Home Manager configuration uses a modular profile system with options that are enabled from NixOS or Darwin host configurations.

- `homeProfiles.*` is system-level input for embedded Home Manager via `osConfig`
- standalone Home Manager modules should set Home Manager option namespaces directly (for example `opencode.*`)
- `homeProfiles.developer.github.enable` imports the GitHub program module, which installs gh/gh-dash and exposes `github.ghDash.*` customization options

**Note:** There are two patterns for feature toggles - user-level features use `homeProfiles.*` options, while system-level features (like desktop environments) use osConfig mirroring. See AGENTS.md for full documentation.

### `homeProfiles.developer.enable`
Enables the developer profile. Includes by default:
- bruno + bruno-cli

Optional sub-options (must also have `homeProfiles.developer.enable = true`):
- `homeProfiles.developer.python.enable` - uv, pre-commit
- `homeProfiles.developer.github.enable` - gh CLI, gh-dash
- `homeProfiles.developer.opencode.enable` - opencode program + config files
- `homeProfiles.developer.aws.enable` - awscli2
- `homeProfiles.developer.go.enable` - Go toolchain
- `homeProfiles.developer.rust.enable` - Rust toolchain (cargo, rust)
- `homeProfiles.developer.lua.enable` - Lua and LuaRocks
- `homeProfiles.developer.containers.enable` - Container and Kubernetes tools
- `homeProfiles.developer.javascript.enable` - Node.js JavaScript runtime
- `homeProfiles.developer.tofu.enable` - tenv-managed OpenTofu/Terraform tooling

### `homeProfiles._3dPrinting.enable`
Enables 3D printing tools (Cura, Cura OctoPrint plugin, FreeCAD)

### `homeProfiles.ai`
AI tooling and policy. Options:

- `homeProfiles.ai.enable` - master switch for AI tooling
- `homeProfiles.ai.nvim.enable` - AI Neovim integrations
- `homeProfiles.ai.providers.githubCopilot.enable` - GitHub Copilot access
- `homeProfiles.ai.providers.supermaven.enable` - Supermaven access
- `homeProfiles.ai.providers.openai.enable` - OpenAI access

Example host configuration:
```nix
homeProfiles = {
  ai = {
    enable = true;
    developer.opencode.enable = true;
    nvim.enable = true;
    providers = {
      githubCopilot.enable = true;
      supermaven.enable = true;
    };
  };
  developer.enable = true;
  developer.python.enable = true;
  developer.tofu.enable = true;
  developer.opencode.enable = true;
  _3dPrinting.enable = true;
};
```

## OpenCode Configuration

OpenCode is managed in two layers:

- raw agents, commands, skills, and plugins live in `modules/home/programs/opencode/config/`
- `~/.config/opencode/opencode.jsonc` is generated from the Home Manager `programs.opencode.settings` options
- the shared baseline installs `rtk` for OpenCode users and links `~/.config/opencode/plugins/rtk.ts` from `pkgs.rtk.src + "/hooks/opencode/rtk.ts"`

Recommended convention:

- keep shared prompts and shared agent behavior in markdown files under `agents/`
- use `programs.opencode.settings` for machine-specific JSON overrides
- for per-machine agent model selection, set `programs.opencode.settings.agent."<agent-name>".model`
- if an agent field needs to vary by machine, leave it out of the shared markdown agent file and set it from JSON instead

Standalone Home Manager modules can set `programs.opencode.*` directly:

```nix
programs.opencode.settings.agent."pr-review-orchestrator".model = "openai/gpt-5";
```

Embedded Home Manager hosts need the `home-manager.users.<name>.` prefix because `programs.opencode.*` is a Home Manager option namespace, not a NixOS or nix-darwin system option namespace:

```nix
home-manager.users.${username}.programs.opencode.settings.agent."pr-review-orchestrator".model = "openai/gpt-5";
```

If you want to avoid that prefix in an embedded host, put the override in a user Home Manager module imported via `home-manager.users.<name>.imports`.

## Reusable Exports

The flake also exposes reusable module entrypoints intended for wrapper flakes and other composition:

- `darwinModules.base` - shared macOS system module stack
- `nixosModules.base` - shared NixOS system module stack
- `homeModules.base` - standalone-safe Home Manager base profile
- `homeModules.system` - Home Manager profile intended for embedded system use via `home-manager.users.<name>.imports`

Wrapper flakes should prefer these exports over copying host composition logic directly.

## Experimental Features

- `hyprland.enable` remains available as an explicit opt-in, but it is experimental and unsupported in this repo.
- The NixOS host in this repo consumes `nixosModules.base`; keep host files focused on host selection and overrides.

## Private Work Overlay

Work-specific configuration is expected to live in a separate repo that owns the final work-machine outputs.

- the private repo should export a top-level wrapper flake
- the private repo should provide `modules/home/default.nix`
- the private repo can compose from `darwinModules.base`, `nixosModules.base`, and `homeModules.*`
- private system hosts should enable shared features through `homeProfiles.*` in the host config and layer private HM overrides with `home-manager.users.<name>.imports`
- private standalone HM outputs should import `homeModules.base` and set direct HM options in their private module

If you need to recreate a minimal private work repo quickly, use `examples/work-overlay-mvp/` as a generic starting point.
It is intentionally organization-neutral and shows the minimum shape for work-only Git, AWS, shell-tool, and OpenCode MCP overrides.

For a fully pure setup, prefer a separate private wrapper flake that:

- pulls this shared repo as a normal flake input from GitHub
- owns the final work machine outputs
- layers its private module on top of these reusable exports
