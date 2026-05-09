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
  if dict.added and dict.added > 0 then
    table.insert(res, "%#GitSignsAdd#" .. git_icons.added .. dict.added)
  end
  if dict.changed and dict.changed > 0 then
    table.insert(res, "%#GitSignsChange#" .. git_icons.modified .. dict.changed)
  end
  if dict.removed and dict.removed > 0 then
    table.insert(res, "%#GitSignsDelete#" .. git_icons.removed .. dict.removed)
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

  local e = count[vim.diagnostic.severity.ERROR]
  local w = count[vim.diagnostic.severity.WARN]
  if e and e > 0 then
    table.insert(res, "%#DiagnosticError#" .. diag_icons.error .. e)
  end
  if w and w > 0 then
    table.insert(res, "%#DiagnosticWarn#" .. diag_icons.warn .. w)
  end

  return join(res)
end

local function codeium_status()
  if not package.loaded["neocodeium"] then
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
  local status, serverStatus = require("neocodeium").get_status()
  return symbols.status[status] .. symbols.server_status[serverStatus] .. " | "
end

local function plugins()
  local stats = require("lazy").stats()
  return string.format(" %d/%d", stats.loaded, stats.count)
end

local function getFileName()
  if vim.bo.buftype == "terminal" then
    return "terminal"
  end
  if not is_wide() then
    return vim.fn.expand "%:t"
  end

  local relative_path = vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
  local home = vim.fn.expand "~"
  relative_path = relative_path:gsub("^" .. vim.pesc(home), "~")

  if #relative_path > 30 then
    local ok, plenary_path = pcall(require, "plenary.path")
    if ok then
      relative_path = plenary_path:new(relative_path):shorten(1)
    end
  end
  return relative_path == "" and "[No Name]" or relative_path
end

function M.statusline()
  local left_section = {
    wrap(mode(), true, "left"),
    wrap(git_branch(), false, "right"),
  }

  local right_section = {}
  if is_wide() then
    right_section = {
      macro(),
      diagnostics(),
      wrap(codeium_status() .. plugins(), false, "left"),
      wrap(getFileName(), true, "right"),
    }
    table.insert(left_section, "  ")
    table.insert(left_section, diff())
  else
    right_section = {
      wrap(codeium_status() .. plugins(), false, "left"),
      wrap(getFileName(), true, "right"),
    }
  end

  return table.concat(left_section) .. "%=" .. table.concat(right_section)
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
