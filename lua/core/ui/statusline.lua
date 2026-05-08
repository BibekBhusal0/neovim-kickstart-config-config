local M = {}

local icons = require("utils.icons")
local git_icons = icons.git
local diag_icons = icons.get_padded_icon("diagnostics")

local SL = {
  sep_l = "",
  sep_r = "",
}

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
  if not ok then return "" end
  local status = git_statusline.get(0)
  if status == "" then return "" end
  return " " .. status .. " "
end

local function diff()
  if vim.o.columns < 100 then return "" end
  local dict = vim.b.gitsigns_status_dict
  if not dict then return "" end
  
  local res = {}
  if dict.added and dict.added > 0 then 
    table.insert(res, "%#StatusLineDiffAdd#" .. git_icons.added .. " " .. dict.added) 
  end
  if dict.changed and dict.changed > 0 then 
    table.insert(res, "%#StatusLineDiffChange#" .. git_icons.modified .. " " .. dict.changed) 
  end
  if dict.removed and dict.removed > 0 then 
    table.insert(res, "%#StatusLineDiffDelete#" .. git_icons.removed .. " " .. dict.removed) 
  end
  
  if #res == 0 then return "" end
  return table.concat(res, " ") .. " "
end

local function macro()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  return "%#StatusLineMacro#recording @" .. reg .. " "
end

local function diagnostics()
  if vim.o.columns < 100 then return "" end
  local count = vim.diagnostic.count(0)
  local res = {}
  
  if count[vim.diagnostic.severity.ERROR] and count[vim.diagnostic.severity.ERROR] > 0 then
    table.insert(res, "%#StatusLineDiagError#" .. diag_icons.error .. count[vim.diagnostic.severity.ERROR])
  end
  if count[vim.diagnostic.severity.WARN] and count[vim.diagnostic.severity.WARN] > 0 then
    table.insert(res, "%#StatusLineDiagWarn#" .. diag_icons.warn .. count[vim.diagnostic.severity.WARN])
  end
  
  if #res == 0 then return "" end
  return table.concat(res, " ") .. " "
end

local function codeium_status()
  if vim.o.columns < 100 then return "" end
  if not package.loaded["neocodeium"] then return "" end
  local symbols = {
    status = { [0] = "󰚩 ", [1] = "󱚧 ", [2] = "󱙻 ", [3] = "󱙺 ", [4] = "󱙺 ", [5] = "󱚠 " },
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
  if vim.bo.buftype == "terminal" then return "terminal" end
  local path = vim.fn.expand("%:t")
  return path == "" and "[No Name]" or path
end

function M.statusline()
  local git = git_branch()
  local git_section = ""
  if git ~= "" then
    git_section = table.concat({
      "%#StatusLineInactiveSep# ", SL.sep_l,
      "%#StatusLineInactive#", git,
      "%#StatusLineInactiveSep#", SL.sep_r,
    })
  end

  return table.concat({
    "%#StatusLineActiveSep#", SL.sep_l,
    "%#StatusLineActive#", mode(),
    "%#StatusLineActiveSep#", SL.sep_r,
    
    git_section,
    
    " ",
    diff(),
    
    "%=",
    
    macro(),
    diagnostics(),
    
    "%#StatusLineInactiveSep#", SL.sep_l,
    "%#StatusLineInactive# ", codeium_status(), plugins(),
    "%#StatusLineInactiveSep#", SL.sep_r,
    
    " ",
    
    "%#StatusLineActiveSep#", SL.sep_l,
    "%#StatusLineActive# ", getFileName(), " ",
    "%#StatusLineActiveSep#", SL.sep_r,
  })
end

function M.apply_colors()
  local colors = {
    active_fg = "#1e1e2e",
    active_bg = "#cba6f7",
    inactive_fg = "#cdd6f4",
    inactive_bg = "#45475a",
    -- Diff/Diag colors (Catppuccin Mocha)
    green  = "#a6e3a1",
    yellow = "#f9e2af",
    red    = "#f38ba8",
    orange = "#ff9e64",
  }

  local function hl(name, val)
    vim.api.nvim_set_hl(0, name, val)
  end

  hl("StatusLine", { bg = "NONE" })
  hl("StatusLineNC", { bg = "NONE" })

  -- Active (Mode, Filename)
  hl("StatusLineActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
  hl("StatusLineActiveSep", { fg = colors.active_bg, bg = "NONE" })

  -- Inactive (Git, Codeium, Plugins)
  hl("StatusLineInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("StatusLineInactiveSep", { fg = colors.inactive_bg, bg = "NONE" })

  -- Middle / Transparent
  hl("StatusLineMacro", { fg = colors.orange, bg = "NONE" })
  
  -- Diff Colors
  hl("StatusLineDiffAdd", { fg = colors.green, bg = "NONE" })
  hl("StatusLineDiffChange", { fg = colors.yellow, bg = "NONE" })
  hl("StatusLineDiffDelete", { fg = colors.red, bg = "NONE" })

  -- Diagnostic Colors
  hl("StatusLineDiagError", { fg = colors.red, bg = "NONE" })
  hl("StatusLineDiagWarn", { fg = colors.yellow, bg = "NONE" })
end

function M.setup()
  M.apply_colors()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      M.apply_colors()
    end,
  })

  vim.opt.statusline = "%!v:lua.require'core.ui.statusline'.statusline()"
  
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    callback = function() vim.cmd("redrawstatus") end,
  })
end

return M
