local M = {}

local icons = require "utils.icons"
-- Get padded icons from the utility
local git_icons = icons.pad_icons(icons.git)
local diag_icons = icons.pad_icons(icons.diagnostics)

local SL = {
  sep_l = "",
  sep_r = "",
}

local function is_wide()
  return vim.o.columns >= 100
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
  return (status == "" and "" or " " .. status .. " ")
end

local function diff()
  if not is_wide() then
    return ""
  end
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

  return #res == 0 and "" or table.concat(res, " ") .. " "
end

local function macro()
  local reg = vim.fn.reg_recording()
  return (reg == "" and "" or "%#StatusLineMacro#recording @" .. reg .. " ")
end

local function diagnostics()
  if not is_wide() then
    return ""
  end
  local count = vim.diagnostic.count(0)
  local res = {}

  if count[vim.diagnostic.severity.ERROR] and count[vim.diagnostic.severity.ERROR] > 0 then
    table.insert(
      res,
      "%#DiagnosticError#" .. diag_icons.error .. count[vim.diagnostic.severity.ERROR]
    )
  end
  if count[vim.diagnostic.severity.WARN] and count[vim.diagnostic.severity.WARN] > 0 then
    table.insert(res, "%#DiagnosticWarn#" .. diag_icons.warn .. count[vim.diagnostic.severity.WARN])
  end

  return #res == 0 and "" or table.concat(res, " ") .. " "
end

local function codeium_status()
  if not is_wide() then
    return ""
  end
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
  return symbols.status[status] .. symbols.server_status[serverStatus]
end

local function plugins()
  local stats = require("lazy").stats()
  return string.format("  %d/%d ", stats.loaded, stats.count)
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
  local git = git_branch()
  local git_section = ""
  if git ~= "" then
    git_section = table.concat {
      "%#StatusLineInactiveSep# ",
      SL.sep_l,
      "%#StatusLineInactive#",
      git,
      "%#StatusLineInactiveSep#",
      SL.sep_r,
    }
  end

  local right_section = ""
  if is_wide() then
    right_section = table.concat {
      "%#StatusLineInactiveSep#",
      SL.sep_l,
      "%#StatusLineInactive# ",
      codeium_status(),
      plugins(),
      "%#StatusLineInactiveSep#",
      SL.sep_r,
      " ",
    }
  end

  return table.concat {
    "%#StatusLineActiveSep#",
    SL.sep_l,
    "%#StatusLineActive#",
    mode(),
    "%#StatusLineActiveSep#",
    SL.sep_r,

    git_section,
    " ",
    diff(),
    "%=",
    macro(),
    diagnostics(),

    right_section,

    "%#StatusLineActiveSep#",
    SL.sep_l,
    "%#StatusLineActive# ",
    getFileName(),
    " ",
    "%#StatusLineActiveSep#",
    SL.sep_r,
  }
end

function M.apply_colors()
  local colors = {
    active_fg = "#1e1e2e",
    active_bg = "#cba6f7",
    inactive_fg = "#cdd6f4",
    inactive_bg = "#45475a",
    orange = "#ff9e64",
  }

  local function hl(name, val)
    -- Default background to NONE if not specified
    if val.bg == nil then
      val.bg = "NONE"
    end
    vim.api.nvim_set_hl(0, name, val)
  end

  hl("StatusLine", { fg = colors.inactive_fg })
  hl("StatusLineNC", { fg = colors.inactive_fg })

  -- Active (Mode, Filename)
  hl("StatusLineActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
  hl("StatusLineActiveSep", { fg = colors.active_bg })

  -- Inactive (Git, Codeium, Plugins)
  hl("StatusLineInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("StatusLineInactiveSep", { fg = colors.inactive_bg })

  -- Middle / Utility
  hl("StatusLineMacro", { fg = colors.orange })

  -- We reuse existing GitSigns and Diagnostic groups which should already be styled
  -- by the colorscheme, or we can link them if they are missing.
end

function M.setup()
  vim.o.laststatus = 3

  M.apply_colors()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      M.apply_colors()
    end,
  })

  vim.opt.statusline = "%!v:lua.require'core.ui.statusline'.statusline()"

  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    callback = function()
      vim.cmd "redrawstatus"
    end,
  })
end

return M
