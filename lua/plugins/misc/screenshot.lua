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
      return (" " .. username .. "/" .. repo_name)
    end
  end
  return get_file_name()
end

local function get_start_line()
  local mode = vim.api.nvim_get_mode().mode
  if mode:match "^v" or mode:match "^V" then
    local start_line = vim.fn.line "'<"
    return start_line - 1
  end
  return 0
end

local function get_line_number_width()
  local mode = vim.api.nvim_get_mode().mode
  local end_line = vim.fn.line "$"

  if mode:match "^v" or mode:match "^V" then
    end_line = vim.fn.line "'>"
  end

  local digits = #tostring(end_line)
  return digits
end

local function get_template_data()
  return {
    title = get_window_title(),
    start_line = get_start_line(),
    line_number_width = get_line_number_width(),
  }
end

---Take Screenshot after setting up snap's config
---@param config SnapUserConfig to overwrite
local function snap(config)
  require("snap.config").set { additional_template_data = get_template_data() }
  require("snap.config").set(config)
  local mode = vim.api.nvim_get_mode().mode
  if mode:match "^v" or mode:match "^V" then
    local s = vim.fn.getpos "v"
    local e = vim.fn.getpos "."
    vim.cmd(string.format("%d,%dSnap", s[2], e[2]))
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
      additional_template_data = {
        title = "",
        start_line = 0,
        line_number_width = 3,
      },
    },
  },
}
