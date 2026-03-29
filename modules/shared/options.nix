{ lib, ... }: {
  options = {
    _3dPrinting.enable = lib.mkEnableOption "Enable 3D printing support";

    ai = {
      enable = lib.mkEnableOption "machine-managed AI tooling and integrations";

      opencode = {
        enable = lib.mkEnableOption "OpenCode package and configuration";
      };

      nvim = {
        enable = lib.mkEnableOption "AI Neovim integrations";
      };

      providers = {
        githubCopilot.enable = lib.mkEnableOption "GitHub Copilot provider access";
        supermaven.enable = lib.mkEnableOption "Supermaven provider access";
        openai.enable = lib.mkEnableOption "OpenAI provider access";
      };
    };
  };
}
