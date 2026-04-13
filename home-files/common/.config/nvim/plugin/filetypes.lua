-- Filetypes configurations
-- Purpose: Set filetypes for files that are not recognized by default

vim.filetype.add({
  extension = {
    tf = "terraform"
  },
  pattern = {
    [".*/defaults/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/meta/.*%.ya?ml"] = "yaml.ansible",
    [".*/molecule/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
  },
  filename = {
    ["playbook.yml"] = "yaml.ansible",
    ["playbook.yaml"] = "yaml.ansible",
    ["site.yml"] = "yaml.ansible",
    ["site.yaml"] = "yaml.ansible",
  }
})
