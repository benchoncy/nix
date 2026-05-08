{ lib, ... }: {
  options = {
    homeProfiles = {
      ai = {
        enable = lib.mkEnableOption "Enable AI tooling and policy";

        opencode.enable = lib.mkEnableOption "OpenCode installation and config";

        nvim.enable = lib.mkEnableOption "AI Neovim integrations";

        providers = {
          githubCopilot.enable = lib.mkEnableOption "GitHub Copilot access";

          supermaven.enable = lib.mkEnableOption "Supermaven access";

          openai.enable = lib.mkEnableOption "OpenAI access";
        };
      };

      developer = {
        enable = lib.mkEnableOption "Enable developer profile";

        python.enable = lib.mkEnableOption "Python and tooling";

        bruno.enable = lib.mkEnableOption "Bruno API client";

        github.enable = lib.mkEnableOption "GitHub CLI and gh-dash";

        opencode.enable = lib.mkEnableOption "OpenCode config files";

        aws.enable = lib.mkEnableOption "AWS CLI and alias";

        go.enable = lib.mkEnableOption "Go toolchain";

        rust.enable = lib.mkEnableOption "Rust toolchain";

        lua.enable = lib.mkEnableOption "Lua and LuaRocks";

        containers.enable = lib.mkEnableOption "Container tools (Podman)";

        javascript.enable = lib.mkEnableOption "Node.js JavaScript runtime";

        tofu.enable = lib.mkEnableOption "OpenTofu and tenv version manager";
      };

      _3dPrinting.enable = lib.mkEnableOption "Enable 3D printing profile (Cura, FreeCAD, OctoPrint)";
    };
  };
}