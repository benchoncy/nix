-- Mason plugin configuration
-- Purpose: Provides a package manager for linters, formatters, etc.

return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            local mason_packages = {
                "ansible-language-server",
                "bash-language-server",
                "clangd",
                "docker-language-server",
                "gopls",
                "helm-ls",
                "json-lsp",
                "ltex-ls",
                "lua-language-server",
                "marksman",
                "ruff",
                "rust-analyzer",
                "taplo",
                "texlab",
                "tflint",
                "tofu-ls",
                "ty",
                "typescript-language-server",
                "yaml-language-server",
            }

            require("mason-tool-installer").setup({
                ensure_installed = mason_packages
            })
        end
    }
}
