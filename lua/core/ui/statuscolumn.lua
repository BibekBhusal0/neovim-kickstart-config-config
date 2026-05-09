local M = {}

local foldcol_enabled = false
local numcol_enabled = true

local ft_ignore =
  { "quickrun", "codecompanion", "terminal", "neo-tree", "nvim-undotree", "alpha", "dashboard" }
local bt_ignore = { "terminal", "nofile", "prompt" }

local function set_dynamic_number_width()
  local line_count = vim.fn.line "$"
  local width = #tostring(line_count)
  if width < 3 then
    width = width + 1
  end
  vim.wo.numberwidth = width
end

local function update_cols()
  vim.wo.number = numcol_enabled
  vim.wo.relativenumber = numcol_enabled
  vim.wo.foldcolumn = foldcol_enabled and "1" or "0"
  set_dynamic_number_width()
end

function M.hide()
  vim.wo.statuscolumn = ""
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.foldcolumn = "0"
end

function M.setup()
  -- DAP signs and other icons
  local icons = require "utils.icons"
  local dap_icons = icons.dap
  for type, icon in pairs(dap_icons) do
    local hl = "Dap" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  -- Folding settings
  vim.o.foldlevelstart = 99
  vim.o.foldenable = false
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldtext = ""
  vim.opt.fillchars = {
    vert = "┃",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    fold = " ",
    eob = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
  }

  local map = require "utils.map"
  local function toggle_foldcolumn()
    foldcol_enabled = not foldcol_enabled
    update_cols()
  end
  map("zi", toggle_foldcolumn, "Toggle fold column")

  local function toggle_line_numbers()
    numcol_enabled = not numcol_enabled
    update_cols()
  end
  map("<leader>nn", toggle_line_numbers, "Toggle Line Numbers")

  local group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })
  vim.defer_fn(function()
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      group = group,
      callback = function()
        if
          vim.tbl_contains(ft_ignore, vim.bo.filetype)
          or vim.tbl_contains(bt_ignore, vim.bo.buftype)
        then
          M.hide()
        else
          vim.wo.statuscolumn = "%!v:lua.require'core.ui.statuscolumn'.statuscolumn()"
          update_cols()
        end
      end,
    })
  end, 1)
end

function M.foldfunc()
  if not foldcol_enabled then
    return ""
  end
  local lnum = vim.v.lnum
  local foldlevel = vim.fn.foldlevel(lnum)
  if foldlevel <= 0 then
    return ""
  end

  local foldclosed = vim.fn.foldclosed(lnum)
  if foldclosed ~= -1 then
    if foldclosed == lnum then
      return ""
    else
      return " "
    end
  end

  if foldlevel > vim.fn.foldlevel(lnum - 1) then
    return ""
  end

  return " "
end

function M.lnumfunc()
  local left_pad = ""
  if foldcol_enabled then
    left_pad = " "
  end

  if not numcol_enabled then
    return left_pad
  end

  local lnum = vim.v.lnum
  local relnum = vim.v.relnum
  local nuw = vim.wo.numberwidth

  local display_str
  if relnum == 0 then
    -- Current line: absolute number, left-aligned in its field, pad right
    local lnum_str = tostring(lnum)
    local pad = (" "):rep(nuw - #lnum_str)
    display_str = lnum_str .. pad
  else
    local relnum_str = tostring(relnum)
    local pad = (" "):rep(nuw - #relnum_str)
    display_str = pad .. relnum_str
  end

  return left_pad .. display_str .. "%="
end

function M.statuscolumn()
  return table.concat {
    M.foldfunc(),
    M.lnumfunc(),
    "%s",
  }
end

return M
