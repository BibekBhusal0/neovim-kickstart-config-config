map = require('utils.map')
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- navigation in insert mode
map("<C-b>", "<ESC>^i", "Move to Begining of line", 'i')
map("<C-e>", "<End>", "Move to End of line", 'i')
map("<C-h>", "<Left>", "Move left", 'i')
map("<C-l>", "<Right>", "Move right", 'i')
map("<C-j>", "<Down>", "Move down", 'i')
map("<C-k>", "<Up>", "Move up", 'i')
map("jj", "<ESC>", "Normal Mode", 'i')
map("<C-c>", "<Esc>", "Normal Mode", 'i')
map("<C-O>", "<Esc>o", "Move to New Line", 'i')
map("<C-]>", "<Esc>ldbi", "Delete Word", 'i')

-- Disable the spacebar key's default behavior in Normal and Visual modes
map("<Space>", "<Nop>", '', { 'n', 'v' })

map("<C-s>", ": w <CR>", 'Save File')

-- quit
map("<leader>sn", ":noautocmd w <CR>", "Save File Without formatting")
map("<C-q>", ": q!<CR>", "Quit File")
map("<leader>xx", ": q <CR>", "Quit File")
map("<leader>xX", ": q!<CR>", "Quit File force")
map("<leader>xa", ":qa<CR>", "Quit all Files")
map("<leader>xA", ":qa!<CR>", "Quit all Files force")
map("<leader>xb", ":bd<CR>", "Quit Buffer")
map("<leader>xB", ":bd!<CR>", "Quit Buffer force")
map("<leader>xt", ":tabclose<CR>", "Quit Tab")
map("<leader>xs", ":close<CR>", "Quit Split")

-- https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
-- move lines in visual mode
map("J", ":m '>+1<CR>gv=gv", "Move Lines Down", 'v')
map("K", ":m '<-2<CR>gv=gv", "Move Lines Up", 'v')

-- copy/paste to system clipboard with leader y
map("<leader>y", '"+y', "Yank to system clipboard", { "n", "v" })
map("<leader>Y", '"+Y', "Yank line to system clipboard")
map('<leader>p', '"_dP', "Paste without yanking", 'x')

-- Vertical scroll and center
map("<C-d>", "<C-d>zz", "Scroll down and center")
map("<C-u>", "<C-u>zz", "Scroll up and center")

-- Find and center
map("n", "nzzzv", "Find next and center")
map("N", "Nzzzv", "Find previous and center")

-- Resize with arrows
map("<Up>", ":resize -2<CR>", "Resize window up")
map("<Down>", ":resize +2<CR>", "Resize window down")
map("<Left>", ":vertical resize -2<CR>", "Resize window left")
map("<Right>", ":vertical resize +2<CR>", "Resize window right")

-- Buffers
map("<Tab>", ":bnext<CR>", "Buffer Cycle Next")
map("<S-Tab>", ":bprevious<CR>", "Buffer Cycle Previous")
map("<leader>bx", ":bdelete!<CR>", "Buffer Delete")
map("<leader>bb", ":enew<CR>", "Buffer New")
map("<leader>bp", ":BufferLineTogglePin<CR>", "Buffer Toggle Pin")
map("<leader>bP", ":BufferLinePick<CR>", "Buffer Pick")
map("<leader>bj", ":BufferLineMoveNext<CR>", "Buffer Move Next")
map("<leader>bk", ":BufferLineMovePrev<CR>", "Buffer Move Prev")
map("<leader>bo", ":BufferLineCloseOthers<CR>", "Buffer Close others")
map("<leader>bh", ":BufferLineCyclePrev<CR>", "Buffer Cycle Prev")
map("<leader>bl", ":BufferLineCycleNext<CR>", "Buffer Cycle Next")
map("<leader>bH", ":BufferLineCloseLeft<CR>", "Buffer Close Prev")
map("<leader>bL", ":BufferLineCloseRight<CR>", "Buffer Close Next")
map("<leader>br", ":e!<CR>", "Buffer Reset")

map("<leader>bse", ":BufferLineSortByExtension<CR>", "Buffer Sort By Extension")
map("<leader>bsr", ":BufferLineSortByRelativeDirectory<CR>", "Buffer Sort By Relative Directory")

for i = 1, 9 do
    map("<leader>b" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", "Buffer Go to " .. i)
end

-- terminal
map("<C-x>", "<C-\\><C-N>", "terminal escape terminal mode", 't')

-- Window management
map("<leader>v", ":vsplit<CR>", "Split window vertically")
map("<leader>h", ":split<CR>", "Split window horizontally")
map("<leader>se", ":winc =<CR>", "Split window equal")
map("<leader>V", ":vsplit | ter<CR>", "Split window vertically")
map("<leader>H", ":split | ter<CR>", "Split window horizontally")

-- Navigate between splits
map("<C-k>", ":wincmd k<CR>", "Window up")
map("<C-j>", ":wincmd j<CR>", "Window down")
map("<C-h>", ":wincmd h<CR>", "Window left")
map("<C-l>", ":wincmd l<CR>", "Window right")

-- Tabs
map("<leader>to", ":tabnew<CR>", "Tab new")
map("<leader>tx", ":tabclose<CR>", "Tab close")
map("<leader>tn", ":tabn<CR>", "Tab next")
map("<leader>tp", ":tabp<CR>", "Tab Previous")

local function gotoTab()
    require 'utils.input' (" Tab ", function(text) vim.cmd("tabn " .. text) end, '', 5)
end
map("<leader>tg", gotoTab, "Tab goto")

-- leader t 0-9 to move between tabs
for i = 1, 9 do
    map("<leader>t" .. i, ":tabn " .. i .. "<CR>", "Tab " .. i)
end

-- Toggle line wrapping
map("<leader>lw", ":set wrap!<CR>", "Toggle line wrapping")

-- Stay in indent mode
map("<", "<gv", "Indent left", "v")
map(">", ">gv", "Indent right", "v")

-- Diagnostic keymaps
map("[d", vim.diagnostic.goto_prev, "Diagnostic previous")
map("]d", vim.diagnostic.goto_next, "Diagnostic next")
map("<leader>dd", vim.diagnostic.open_float, "Diagnostic floating")
map("<leader>dl", vim.diagnostic.setloclist, "Diagnostic list")

-- line numbers
map("<leader>n", ":set nu!<CR>", "Toggle Line Number")
map("<leader>rn", ":set rnu!<CR>", "Toggle Relative Line Number")

-- folding
local function toggle_foldcolumn()
    if vim.o.foldcolumn == "0" then
        vim.o.foldcolumn = "1"
    else
        vim.o.foldcolumn = "0"
    end
end

map('zo', 'za', "Toggle fold")
map('zi', toggle_foldcolumn, "Toggle fold column")
