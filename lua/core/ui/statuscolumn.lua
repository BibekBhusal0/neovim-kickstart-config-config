local M = {}
local ft_ignore = { "quickrun", "codecompanion", "terminal", "neo-tree" }
local bt_ignore = { "terminal", "nofile" }

local function set_dynamic_number_width()
  local line_count = vim.fn.line "$"
  local width = #tostring(line_count)
  if width < 3 then
    width = width + 1
  end
  vim.wo.numberwidth = width
end

function M.setup()
  vim.api.nvim_create_augroup("DynamicNumberWidth", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = "DynamicNumberWidth",
    callback = set_dynamic_number_width,
  })

  -- DAP signs and other icons
  local icons = require "utils.icons"
  local dap_icons = icons.dap
  for type, icon in pairs(dap_icons) do
    local hl = "Dap" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  -- Folding settings
  vim.o.foldcolumn = "0"
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
    if vim.o.foldcolumn == "0" then
      vim.o.foldcolumn = "1"
    else
      vim.o.foldcolumn = "0"
    end
    set_dynamic_number_width()
  end
  map("zi", toggle_foldcolumn, "Toggle fold column")

  local function toggle_line_numbers()
    if vim.wo.relativenumber then
      vim.wo.relativenumber = false
      vim.wo.number = false
    else
      vim.wo.relativenumber = true
      vim.wo.number = true
    end
    set_dynamic_number_width()
  end
  map("<leader>nn", toggle_line_numbers, "Toggle Line Numbers")

  local group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = group,
    callback = function()
      if
        vim.tbl_contains(ft_ignore, vim.bo.filetype) or vim.tbl_contains(bt_ignore, vim.bo.buftype)
      then
        vim.wo.statuscolumn = ""
      else
        vim.wo.statuscolumn = "%!v:lua.require'core.ui.statuscolumn'.statuscolumn()"
      end
    end,
  })
end

function M.foldfunc()
  if vim.o.foldcolumn == "0" then
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
      return "" -- foldclose icon
    else
      return " "
    end
  end

  if foldlevel > vim.fn.foldlevel(lnum - 1) then
    return "" -- foldopen icon
  end

  return " "
end

function M.lnumfunc()
  local left_pad = ""
  if vim.o.foldcolumn == "1" then
    left_pad = " "
  end

  if not vim.wo.relativenumber then
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
