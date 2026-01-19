local map = require "utils.map"
local function set_dynamic_number_width()
  local line_count = vim.fn.line "$"
  local width = #tostring(line_count)
  if width < 3 then
    width = width + 1
  end
  vim.wo.numberwidth = width
end

vim.api.nvim_create_augroup("DynamicNumberWidth", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "DynamicNumberWidth",
  callback = set_dynamic_number_width,
})

local function lnumfunc(args)
  local left_pad = ""
  if vim.o.foldcolumn == "1" then
    left_pad = " "
  end
  if not args.rnu and not args.nu then
    return left_pad
  end
  if args.virtnum ~= 0 then
    return left_pad .. "%="
  end
  local lnum_n = args.rnu and (args.relnum > 0 and args.relnum or (args.nu and args.lnum or 0))
    or args.lnum
  local lnum = tostring(lnum_n)
  local pad = (" "):rep(args.nuw - #lnum)
  if args.relnum == 0 and args.rnu then
    return left_pad .. lnum .. pad .. "%="
  else
    return left_pad .. "%=" .. pad .. lnum
  end
end

-- folding
local function toggle_foldcolumn()
  if vim.o.foldcolumn == "0" then
    vim.o.foldcolumn = "1"
  else
    vim.o.foldcolumn = "0"
  end
  set_dynamic_number_width()
end
map("zi", toggle_foldcolumn, "Toggle fold column")

vim.o.foldcolumn = "0"
vim.o.foldlevelstart = 99
vim.o.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ref: https://github.com/neovim/neovim/pull/20750
vim.opt.foldtext = ""
vim.opt.fillchars:append "fold: "
vim.opt.fillchars = { fold = " ", eob = " ", foldopen = "", foldsep = " ", foldclose = "" }

-- local diag_icons = require("utils.icons").diagnostics
-- local signs = { text = {} }
-- vim.diagnostic.config { signs = signs }
-- for type, icon in pairs(diag_icons) do
--   local severity = vim.diagnostic.severity[type:upper()]
--   signs.text[severity] = icon
-- end

for type, icon in pairs(require("utils.icons").dap) do
  local hl = "Dap" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

return {
  "luukvbaal/statuscol.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa", auto = true },
        { text = { lnumfunc }, click = "v:lua.ScLa", auto = true },
        { text = { "%s" }, click = "v:lua.ScSa", auto = true },
      },
      ft_ignore = { "quickrun", "codecompanion", "terminal" },
      bt_ignore = { "terminal" },
    }
  end,
}
