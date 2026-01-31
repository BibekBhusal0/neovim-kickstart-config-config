vim.wo.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.linebreak = true
vim.o.mouse = "a"
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor (default: 0)
vim.o.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
vim.o.cursorline = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.showmode = false
vim.opt.termguicolors = true
vim.o.whichwrap = "bs<>[]hl" -- Which "horizontal" keys are allowed to travel to prev/next line (default: "b,s")
vim.o.numberwidth = 4 -- Set number column width to 2 {default 4} (default: 4)
vim.o.swapfile = false
vim.o.smartindent = true
vim.o.showtabline = 2
vim.o.backspace = "indent,eol,start" -- Allow backspace on (default: "indent,eol,start")
vim.o.pumheight = 10 -- Pop up menu height (default: 0)
vim.o.conceallevel = 0 -- So that `` is visible in markdown files (default: 1)
vim.wo.signcolumn = "yes"
vim.o.fileencoding = "utf-8"
vim.o.cmdheight = 1
vim.o.breakindent = true
vim.o.updatetime = 250
vim.o.timeoutlen = 800 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.backup = false
vim.o.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile = true
vim.o.completeopt = "menuone,noselect"
vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-" -- Hyphenated words recognized by searches (default: does not include "-")
vim.opt.runtimepath:remove "/usr/share/vim/vimfiles" -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)
vim.o.mousemoveevent = true

vim.opt.hlsearch = true
-- spell
vim.opt.spelllang = "en_us"
vim.opt.spell = false
vim.opt.spelloptions = "camel"

-- Hiding scroll bar in those filetypes
vim.cmd [[
  autocmd FileType telescope,mason,lazygit,nvcheatsheet setlocal nospell
]]

-- Don't insert the current comment leader automatically for auto-wrapping <Enter> in insert mode, or hitting "o" or "O" in normal mode.
vim.cmd [[
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r
]]
