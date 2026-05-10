local M = {}

local icons = require "utils.icons"
local wrap = require "utils.wrap"
local git_icons = icons.pad_icons(icons.git)
local diag_icons = icons.pad_icons(icons.diagnostics)

local function is_wide()
  return vim.o.columns >= 100
end

local function join(res)
  return #res == 0 and "" or table.concat(res, " ") .. " "
end

local function mode()
  local m = vim.fn.mode()
  local mode_names = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    R = "REPLACE",
    t = "TERMINAL",
  }
  return " " .. (mode_names[m] or m) .. " "
end

local function git_branch()
  local ok, git_statusline = pcall(require, "git_statusline")
  if not ok then
    return ""
  end
  local status = git_statusline.get(0)
  return (status == "" and " - " or " " .. status .. " ")
end

local function diff()
  local dict = vim.b.gitsigns_status_dict
  if not dict then
    return ""
  end

  local res = {}
  local items = {
    { "added", git_icons.added, "%#GitSignsAdd#" },
    { "changed", git_icons.modified, "%#GitSignsChange#" },
    { "removed", git_icons.removed, "%#GitSignsDelete#" },
  }

  for _, item in ipairs(items) do
    local val = dict[item[1]]
    if val and val > 0 then
      table.insert(res, item[3] .. item[2] .. val)
    end
  end

  return join(res)
end

local function macro()
  local reg = vim.fn.reg_recording()
  return (reg == "" and "" or "%#UIOrange#recording @" .. reg .. " ")
end

local function diagnostics()
  local count = vim.diagnostic.count(0)
  local res = {}
  local levels = {
    { vim.diagnostic.severity.ERROR, diag_icons.error, "%#DiagnosticError#" },
    { vim.diagnostic.severity.WARN, diag_icons.warn, "%#DiagnosticWarn#" },
    { vim.diagnostic.severity.INFO, diag_icons.info, "%#DiagnosticInfo#" },
    { vim.diagnostic.severity.HINT, diag_icons.hint, "%#DiagnosticHint#" },
  }

  for _, level in ipairs(levels) do
    local n = count[level[1]]
    if n and n > 0 then
      table.insert(res, level[3] .. level[2] .. n)
    end
  end

  return join(res)
end

local function codeium_status()
  local ok, neocodeium = pcall(require, "neocodeium")
  if not ok then
    return ""
  end
  local symbols = {
    status = {
      [0] = "󰚩 ",
      [1] = "󱚧 ",
      [2] = "󱙻 ",
      [3] = "󱙺 ",
      [4] = "󱙺 ",
      [5] = "󱚠 ",
    },
    server_status = { [0] = "󰣺 ", [1] = "󰣻 ", [2] = "󰣽 " },
  }
  local status, serverStatus = neocodeium.get_status()
  return symbols.status[status] .. symbols.server_status[serverStatus] .. " | "
end

local function plugins()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    return ""
  end
  local stats = lazy.stats()
  return string.format(" %d/%d", stats.loaded, stats.count)
end

local function getFileName()
  if vim.bo.buftype == "terminal" then
    return "terminal"
  end

  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  if name:match "^diffview://" then
    local path = name:match "%.git/[a-f0-9]+/(.*)$"
    name = path and ("DV: " .. path) or name:gsub("^diffview://", "")
  else
    if not is_wide() then
      name = vim.fn.fnamemodify(name, ":t")
    else
      name = vim.fn.fnamemodify(name, ":.")
      local home = vim.fn.expand "~"
      name = name:gsub("^" .. vim.pesc(home), "~")
    end
  end

  if #name > 30 then
    local ok, plenary_path = pcall(require, "plenary.path")
    if ok then
      name = plenary_path:new(name):shorten(1)
    end
  end

  if #name > 30 then
    name = "..." .. name:sub(-27)
  end

  return name
end

function M.statusline()
  local left = {
    wrap(mode(), true, "left"),
    wrap(git_branch(), false, "right"),
  }

  local wide = is_wide()
  if wide then
    table.insert(left, "  ")
    table.insert(left, diff())
  end

  local right = {
    wide and macro() or "",
    wide and diagnostics() or "",
    wrap(codeium_status() .. plugins(), false, "left"),
    wrap(getFileName(), true, "right"),
  }

  return table.concat(left) .. "%=" .. table.concat(right)
end

function M.setup()
  vim.o.laststatus = 3
  vim.opt.statusline = "%!v:lua.require'core.ui.statusline'.statusline()"

  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    callback = function()
      vim.cmd "redrawstatus"
    end,
  })
end

return M
