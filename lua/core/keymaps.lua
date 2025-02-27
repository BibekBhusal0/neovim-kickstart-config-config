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
map("<leader>xt", ":tabclose<CR>", "Quit Tab")
map("<leader>xs", ":close<CR>", "Quit Split")

-- https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
--
-- move lines in visual mode
map("J", ":m '>+1<CR>gv=gv", "Move Lines Down", 'v')
map("K", ":m '<-2<CR>gv=gv", "Move Lines Up", 'v')

-- copy/paste to system clipboard with leader y
map("<leader>y", '"+y', "Yank to system clipboard", { "n", "v" })
map("<leader>Y", '"+Y', "Yank line to system clipboard")
map("<leader>j", 'ggVGy', "Yank all")
map("<leader>J", 'ggVG"+y', "Yank all to System Clipboard")
map('<leader>p', '"_dP', "Paste without yanking", 'x')

-- Vertical scroll and center
map("<C-d>", "<C-d>zz", "Scroll down and center")
map("<C-u>", "<C-u>zz", "Scroll up and center")

-- center movements 
map("<A-j>", "jzz", "Move Next line and center")
map("<A-k>", "kzz", "Move Previous line and center")

-- Move lines 
map("<A-J>", ":m .+1<CR>==", "Move line down")
map("<A-K>", ":m .-2<CR>==", "Move line up")

-- terminal
map("<C-x>", "<C-\\><C-N>", "terminal escape terminal mode", 't')

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
map("<leader>nn", ":set nu!<CR>", "Toggle Line Number")
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
