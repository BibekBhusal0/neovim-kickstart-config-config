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

--- Get start and end line numbers for current selection or for entire file.
-- @treturn { start: number, ["end"]: number }.
local function get_start_end_line()
  local mode = vim.api.nvim_get_mode().mode
  if mode:match "^v" or mode:match "^V" or mode == "\22" then
    local s = vim.fn.getpos("v")[2]
    local e = vim.fn.getpos(".")[2]
    if s > e then
      return { start = e, ["end"] = s }
    end
    return { start = s, ["end"] = e }
  end

  return { start = 1, ["end"] = vim.fn.line "$" }
end

---Take Screenshot after setting up snap's config
---@param config SnapUserConfig to overwrite
local function snap(config)
  local s = get_start_end_line()
  require("snap.config").set {
    additional_template_data = {
      title = get_window_title(),
      start_line = s.start - 1,
      line_number_width = #tostring(s["end"]),
    },
  }
  require("snap.config").set(config)
  vim.cmd(string.format("%d,%dSnap", s.start, s["end"]))
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
