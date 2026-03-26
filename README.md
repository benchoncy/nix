# Nix Configurations

This repository contains Nix configurations for target systems with the intent of creating a fully reproducible environment. The configuration aims to be used with NixOS or Nix on other Unix systems to produce my development environment across different machines.

# Usage

## NixOS

To use this configuration on NixOS, follow these steps:
1. Follow the [NixOS installation instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation) to install NixOS
2. Follow the [wiki instructions](https://nixos.wiki/wiki/Displaylink) to prefetch the DisplayLink non-free blob.
3. use `make nixos-rebuild` to create a new configuration

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

## Home Manager Only

The flake exposes standalone Home Manager outputs for dotfiles-only workflows.

- `home-manager switch --flake .#nixos-bstuart-home`
- `make home-manager`

Work-only standalone Home Manager outputs are expected to live in the private wrapper flake, not this shared repo.

## Raw Dotfiles

The repo supports raw dotfile copying through an explicit Home Manager manifest.

- shared raw files live under `home-files/common/`
- raw ownership is declared in `modules/home/capabilities/raw-files-compat.nix`
- prefer whole app directories under `.config/<app>` instead of one giant `.config` mapping
- keep reserved/generated files like `.gitconfig`, `.ssh/config`, `.aws/config`, `.config/ghostty/config`, and `.config/opencode/opencode.jsonc` in Home Manager modules rather than raw copies

## Reusable Exports

The flake also exposes reusable module entrypoints intended for wrapper flakes and other composition:

- `darwinModules.base` - shared macOS system module stack
- `nixosModules.base` - shared NixOS system module stack
- `homeModules.base` - standalone-safe Home Manager base profile
- `homeModules.system` - Home Manager profile intended for embedded system use

Wrapper flakes should prefer these exports over copying host composition logic directly.

## Private Work Overlay

Work-specific configuration is expected to live in a separate repo that owns the final work-machine outputs.

- the private repo should export a top-level wrapper flake
- the private repo should provide `modules/home/default.nix`
- the private repo can compose from `darwinModules.base`, `nixosModules.base`, and `homeModules.*`

If you need to recreate a minimal private work repo quickly, use `examples/work-overlay-mvp/` as a generic starting point.
It is intentionally organization-neutral and shows the minimum shape for work-only Git, AWS, shell-tool, and OpenCode MCP overrides.

For a fully pure setup, prefer a separate private wrapper flake that:

- pulls this shared repo as a normal flake input from GitHub
- owns the final work machine outputs
- layers its private module on top of these reusable exports
