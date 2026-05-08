local M = {}

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

  -- Keymap for toggling foldcolumn
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
    if vim.wo.relativenumber or vim.wo.number then
      vim.wo.relativenumber = false
      vim.wo.number = false
    else
      vim.wo.relativenumber = true
      vim.wo.number = true
    end
    set_dynamic_number_width()
  end
  map("<leader>nn", toggle_line_numbers, "Toggle Line Numbers")

  -- Set statuscolumn
  vim.opt.statuscolumn = "%!v:lua.require'core.statuscolumn'.statuscolumn()"
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
  local nu = vim.wo.number
  local rnu = vim.wo.relativenumber
  local lnum = vim.v.lnum
  local relnum = vim.v.relnum
  local virtnum = vim.v.virtnum
  local nuw = vim.wo.numberwidth

  local left_pad = ""
  if vim.o.foldcolumn == "1" then
    left_pad = " "
  end

  if not rnu and not nu then
    return left_pad
  end

  if virtnum ~= 0 then
    return left_pad .. "%="
  end

  local lnum_n = rnu and (relnum > 0 and relnum or (nu and lnum or 0)) or lnum
  local lnum_str = tostring(lnum_n)
  local pad = (" "):rep(nuw - #lnum_str)

  if relnum == 0 and rnu then
    return left_pad .. lnum_str .. pad .. "%="
  else
    return left_pad .. "%=" .. pad .. lnum_str
  end
end

local ft_ignore = { "quickrun", "codecompanion", "terminal", "neo-tree" }
local bt_ignore = { "terminal", "nofile" }

function M.statuscolumn()
  if vim.tbl_contains(ft_ignore, vim.bo.filetype) or vim.tbl_contains(bt_ignore, vim.bo.buftype) then
    return ""
  end

  return table.concat({
    M.foldfunc(),
    M.lnumfunc(),
    "%s",
  })
end

return M
