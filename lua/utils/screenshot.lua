local M = {}

M.defaultTemplate = {
  line_number = {
    start = 0,
    width = 0,
  },
  file_name = {
    name = "",
    icon = "",
    color = "",
  },
  git = "",
}

--- Get start and end line numbers for current selection or for entire file.
-- @treturn { name: string, icon: string, color: string }.
function M.get_file_name()
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
  local icon, color = require("nvim-web-devicons").get_icon_color(name)
  return { name = name, icon = icon, color = color }
end

---Get current github repo
---@return string
function M.get_repo()
  local repo_url = vim.fn.system "git config --get remote.origin.url"
  if repo_url and repo_url ~= "" then
    repo_url = vim.fn.trim(repo_url)
    local username, repo_name = repo_url:match "https://github.com/([^/]+)/([^/]+)"
    if username and repo_name then
      repo_name = repo_name:gsub("%.git$", "")
      return (require("utils.icons").others.github .. " /" .. username .. "/" .. repo_name)
    end
  end
  return ""
end

return M
