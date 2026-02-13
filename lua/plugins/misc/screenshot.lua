local wrap_keys = require "utils.wrap_keys"

local defaultTemplate = {
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

local get_file_name = function()
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
  local icon, color = require("nvim-web-devicons").get_icon_color(name)
  return { name = name, icon = icon, color = color }
end

local function get_repo()
  local repo_url = vim.fn.system "git config --get remote.origin.url"
  if repo_url and repo_url ~= "" then
    repo_url = vim.fn.trim(repo_url)
    local username, repo_name = repo_url:match "https://github.com/([^/]+)/([^/]+)"
    if username and repo_name then
      repo_name = repo_name:gsub("%.git$", "")
      return (require("utils.icons").others.github .. " /" .. username .. "/" .. repo_name)
    end
  end
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
      line_number = {
        start = s.start - 1,
        width = #tostring(s["end"]),
        show = true,
      },
      file_name = get_file_name(),
      git = get_repo(),
    },
  }
  require("snap.config").set(config)
  vim.cmd(string.format("%d,%dSnap", s.start, s["end"]))
  -- Reset the config for snap
  vim.defer_fn(function()
    require("snap.config").set { additional_template_data = defaultTemplate }
  end, 2000)
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
      templateFilepath = vim.fn.stdpath "config" .. "/snap/template.html",
      save_to_disk = { image = true },
      output_dir = "~/Code/Screenshots/",
      filename_pattern = "%file_name.%file_extension-%t",
      additional_template_data = defaultTemplate,
    },
  },
}
