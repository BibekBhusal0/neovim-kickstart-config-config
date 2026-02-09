local wrap_keys = require "utils.wrap_keys"

local config_path = vim.fn.stdpath "config"
local template = config_path .. "/snap/template.html"
local screenshotFolder = "~/Code/Screenshots/"

local get_file_name = function()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
end

local function get_window_title()
  local repo_url = vim.fn.system "git config --get remote.origin.url"
  if repo_url and repo_url ~= "" then
    repo_url = vim.fn.trim(repo_url)
    local username, repo_name = repo_url:match "https://github.com/([^/]+)/([^/]+)"
    if username and repo_name then
      repo_name = repo_name:gsub("%.git$", "")
      return ("  " .. username .. "/" .. repo_name)
    end
  end
  return "   " .. get_file_name()
end

local function get_template_data()
  local background = "#000000"
  if require("utils.transparency").bg_transparent then
    background = "transparent"
  end
  return {
    title = get_window_title(),
    background = background,
  }
end

---Take Screenshot after setting up snap's config
---@param config SnapUserConfig to overwrite
local function snap(config)
  require("snap.config").set { additional_template_data = get_template_data() }
  require("snap.config").set(config)
  local mode = vim.api.nvim_get_mode().mode
  if mode:match "^v" or mode:match "^V" then
    vim.cmd "'<,'>Snap"
    return
  end
  vim.cmd "Snap"
end

local function snap_to_desktop()
  snap {
    save_to_disk = { image = true },
    copy_to_clipboard = { image = false },
  }
end

local function snap_to_clipboard()
  snap {
    save_to_disk = { image = false },
    copy_to_clipboard = { image = true },
  }
end

return {
  {
    "mistweaverco/snap.nvim",
    cmd = "Snap",
    keys = wrap_keys {
      { "<leader>sc", snap_to_clipboard, desc = "Screenshot to clipboard", mode = { "n", "v" } },
      { "<leader>sC", snap_to_desktop, desc = "Screenshot to desktop", mode = { "n", "v" } },
    },
    opts = {
      templateFilepath = template,
      save_to_disk = { image = true },
      output_dir = screenshotFolder,
      filename_pattern = "%file_name.%file_extension-%t",
    },
  },
}
