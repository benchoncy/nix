local M = {}

local defaults = {
  enable = false,
  opencode = {
    enable = false,
  },
  nvim = {
    enable = false,
  },
  providers = {
    githubCopilot = { enable = false },
    supermaven = { enable = false },
    openai = { enable = false },
  },
}

local function read_policy_file(path)
  if vim.fn.filereadable(path) == 0 then
    return nil
  end

  local lines = vim.fn.readfile(path)
  local ok, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok or type(decoded) ~= "table" then
    return nil
  end

  return decoded
end

function M.load()
  local path = vim.fn.expand("~/.config/userdata/ai-policy.json")
  local policy = vim.tbl_deep_extend("force", defaults, read_policy_file(path) or {})

  policy.nvim.enable = policy.enable and policy.nvim.enable
  policy.providers.githubCopilot.enable = policy.enable and policy.providers.githubCopilot.enable
  policy.providers.supermaven.enable = policy.enable and policy.providers.supermaven.enable
  policy.providers.openai.enable = policy.enable and policy.providers.openai.enable

  return policy
end

return M
