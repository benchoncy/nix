---@type vim.lsp.Config
return {
    cmd = { "ansible-language-server", "--stdio" },
    filetypes = { "yaml.ansible" },
    root_markers = {
        "ansible.cfg",
        ".ansible-lint",
        ".ansible-lint.yml",
        ".ansible-lint.yaml",
        "requirements.yml",
        "requirements.yaml",
        "collections/requirements.yml",
        "collections/requirements.yaml",
    },
    settings = {},
}
