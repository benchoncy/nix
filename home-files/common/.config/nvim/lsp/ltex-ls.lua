---@type vim.lsp.Config

local username = vim.env.LANGUAGETOOL_USERNAME or ""
local api_key = vim.env.LANGUAGETOOL_API_KEY or ""

return {
    cmd = { "ltex-ls" },
    filetypes = { "gitcommit", "latex", "markdown", "text", "tex" },
    root_markers = { ".git" },
    settings = {
        ltex = {
            language = "en-GB",
            enabled = { "gitcommit", "latex", "markdown", "text", "tex" },
            languageToolHttpServerUri = "https://api.languagetoolplus.com/",
            languageToolOrg = {
                username = username,
                apiKey = api_key,
            },
            markdown = {
                nodes = {
                    AutoLink = "dummy",
                    Code = "dummy",
                    CodeBlock = "ignore",
                    FencedCodeBlock = "ignore",
                },
            },
        },
    },
}
