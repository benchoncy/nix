# OpenCode skills

This module manages the shared OpenCode configuration and local skills. Remote
skill repositories can be added declaratively from a wrapper flake without
copying their files into this repository.

## Declaring a remote skill repository

Add the repository as a pinned, non-flake input in the wrapper's `flake.nix`:

```nix
inputs = {
  remoteSkills = {
    url = "git+https://github.example.com/team/skills.git?rev=<commit-sha>";
    flake = false;
  };
};
```

The wrapper must pass `inputs` to its Home Manager modules. This repository's
flake already does that through `specialArgs`.

Expose every skill directory under the repository's `skills/` directory:

```nix
{ inputs, lib, ... }:
{
  programs.opencode.skills =
    lib.mapAttrs'
      (name: _: lib.nameValuePair name (inputs.remoteSkills + "/skills/${name}"))
      (lib.filterAttrs
        (_: type: type == "directory")
        (builtins.readDir (inputs.remoteSkills + "/skills")));
}
```

Each skill directory must contain a `SKILL.md` file with valid OpenCode skill
frontmatter. The directory name must match the skill's `name` field.

## Updating the repository

Use a reviewed commit SHA rather than a branch or tag. After changing the
`rev`, refresh the wrapper lock file:

```sh
nix flake lock
nix flake check
```

The pinned revision and its content hash are then recorded in `flake.lock`.

For private Git repositories, Nix must be able to authenticate to the host
while locking or evaluating the flake. Configure Git credentials on each work
machine; do not put tokens in the flake URL or Nix expressions.

Restart OpenCode after switching the Home Manager configuration so it reloads
the newly installed skills.
