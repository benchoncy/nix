{ lib, ... }:
let
  inherit (lib) hasPrefix listToAttrs nameValuePair optionalAttrs unique;

  commonRoot = ../../../home-files/common;

  mkEntry = entry:
    nameValuePair entry.target ({
      source = entry.source;
    }
    // optionalAttrs (entry ? recursive && entry.recursive) {
      recursive = true;
    }
    // optionalAttrs (entry ? executable && entry.executable) {
      executable = true;
    });

  commonRawDirs = [
    {
      target = ".config/nvim";
      source = commonRoot + "/.config/nvim";
      recursive = true;
    }
    {
      target = ".config/shell";
      source = commonRoot + "/.config/shell";
      recursive = true;
    }
  ];

  commonRawFiles = [
    {
      target = ".zshrc";
      source = commonRoot + "/.zshrc";
    }
    {
      target = ".bashrc";
      source = commonRoot + "/.bashrc";
    }
    {
      target = ".config/starship.toml";
      source = commonRoot + "/.config/starship.toml";
    }
    {
      target = ".config/diffnav/config.yml";
      source = commonRoot + "/.config/diffnav/config.yml";
    }
    {
      target = ".aws/cli/alias";
      source = commonRoot + "/.aws/cli/alias";
    }
    {
      target = ".config/opencode/agents/consensus-planning.md";
      source = commonRoot + "/.config/opencode/agents/consensus-planning.md";
    }
    {
      target = ".config/opencode/agents/foreman.md";
      source = commonRoot + "/.config/opencode/agents/foreman.md";
    }
    {
      target = ".config/opencode/agents/crew-planner.md";
      source = commonRoot + "/.config/opencode/agents/crew-planner.md";
    }
    {
      target = ".config/opencode/agents/crew-explorer.md";
      source = commonRoot + "/.config/opencode/agents/crew-explorer.md";
    }
    {
      target = ".config/opencode/agents/crew-implementer.md";
      source = commonRoot + "/.config/opencode/agents/crew-implementer.md";
    }
    {
      target = ".config/opencode/agents/crew-tester.md";
      source = commonRoot + "/.config/opencode/agents/crew-tester.md";
    }
    {
      target = ".config/opencode/agents/crew-reviewer.md";
      source = commonRoot + "/.config/opencode/agents/crew-reviewer.md";
    }
    {
      target = ".config/opencode/agents/pr-review-orchestrator.md";
      source = commonRoot + "/.config/opencode/agents/pr-review-orchestrator.md";
    }
    {
      target = ".config/opencode/agents/pr-review-balanced.md";
      source = commonRoot + "/.config/opencode/agents/pr-review-balanced.md";
    }
    {
      target = ".config/opencode/agents/pr-review-critical.md";
      source = commonRoot + "/.config/opencode/agents/pr-review-critical.md";
    }
    {
      target = ".config/opencode/agents/pr-review-security.md";
      source = commonRoot + "/.config/opencode/agents/pr-review-security.md";
    }
    {
      target = ".config/opencode/agents/pr-review-tester.md";
      source = commonRoot + "/.config/opencode/agents/pr-review-tester.md";
    }
    {
      target = ".config/opencode/commands/consensus-plan.md";
      source = commonRoot + "/.config/opencode/commands/consensus-plan.md";
    }
    {
      target = ".config/opencode/commands/review.md";
      source = commonRoot + "/.config/opencode/commands/review.md";
    }
    {
      target = ".config/opencode/commands/open-pr.md";
      source = commonRoot + "/.config/opencode/commands/open-pr.md";
    }
    {
      target = ".config/opencode/skills/pr-review-foundation/SKILL.md";
      source = commonRoot + "/.config/opencode/skills/pr-review-foundation/SKILL.md";
    }
    {
      target = ".config/opencode/skills/spec-driven-development/SKILL.md";
      source = commonRoot + "/.config/opencode/skills/spec-driven-development/SKILL.md";
    }
    {
      target = ".config/opencode/skills/test-driven-development/SKILL.md";
      source = commonRoot + "/.config/opencode/skills/test-driven-development/SKILL.md";
    }
    {
      target = ".config/opencode/skills/consensus-plan/SKILL.md";
      source = commonRoot + "/.config/opencode/skills/consensus-plan/SKILL.md";
    }
  ];

  commonExecutableFiles = [
    {
      target = ".local/scripts/git-afforester";
      source = commonRoot + "/.local/scripts/git-afforester";
      executable = true;
    }
    {
      target = ".local/scripts/tmux-sessionizer";
      source = commonRoot + "/.local/scripts/tmux-sessionizer";
      executable = true;
    }
    {
      target = ".local/scripts/tmux-windowizer";
      source = commonRoot + "/.local/scripts/tmux-windowizer";
      executable = true;
    }
    {
      target = ".local/scripts/gh-dash-pr-review";
      source = commonRoot + "/.local/scripts/gh-dash-pr-review";
      executable = true;
    }
  ];

  rawEntries = commonRawDirs
    ++ commonRawFiles
    ++ commonExecutableFiles;

  rawFiles = listToAttrs (map mkEntry rawEntries);
  targets = map (entry: entry.target) rawEntries;

  reservedTargets = [
    ".gitconfig"
    ".ssh/config"
    ".aws/config"
    ".config/ghostty/config"
    ".config/gh-dash/config.yml"
    ".config/opencode/opencode.jsonc"
  ];

  conflictingTargets = builtins.filter (
    target:
    builtins.any (
      reservedTarget: target == reservedTarget || hasPrefix "${target}/" reservedTarget
    ) reservedTargets
  ) targets;

  duplicateTargets = builtins.filter (
    target: builtins.length (builtins.filter (candidate: candidate == target) targets) > 1
  ) targets;
in {
  assertions = [
    {
      assertion = conflictingTargets == [ ];
      message = "home-files compatibility layer cannot manage reserved targets: ${builtins.concatStringsSep ", " conflictingTargets}";
    }
    {
      assertion = builtins.length targets == builtins.length (unique targets);
      message = "home-files compatibility layer has duplicate targets: ${builtins.concatStringsSep ", " (unique duplicateTargets)}";
    }
  ];

  home.file = rawFiles;
}
