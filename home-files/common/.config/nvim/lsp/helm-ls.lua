---@type vim.lsp.Config
return {
    cmd = { "helm_ls", "serve" },
    filetypes = { "helm", "yaml" },
    root_markers = { "Chart.yaml" },
    settings = {},
}
