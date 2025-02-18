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

map("<C-s>", "<cmd> w <CR>", 'Save File')
map("<leader>sn", "<cmd>noautocmd w <CR>", "Save File Without Auto-formatting")
map("<C-q>", "<cmd> q <CR>", "Quit File")

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
map("<Down>", ":resize +2<CR>"", "Resize window down")
map("<Left>", ":vertical resize -2<CR>"", "Resize window left")
map("<Right>", ":vertical resize +2<CR>"", "Resize window right")

-- Buffers
map("<Tab>", ":bnext", "Next buffer<CR>"")
map("<S-Tab>", ":bprevious", "Previous buffer<CR>"")
map("<leader>x", ":bdelete!", "Close buffer<CR>"")
map("<leader>b", ":enew", "New buffer<CR>"")

-- Window management
map("<leader>v", ":vsplit<CR>"", "Split window vertically")
map("<leader>h", ":split<CR>"", "Split window horizontally")
map("<leader>se", ":winc =<CR>"", "Make split windows equal width & height")
map("<leader>xs", ":close<CR>"", "Close current split window")

-- Navigate between splits
map("<C-k>", ":wincmd k<CR>", "Go to previous window")
map("<C-j>", ":wincmd j<CR>", "Go to next window")
map("<C-h>", ":wincmd h<CR>", "Go to left window")
map("<C-l>", ":wincmd l<CR>", "Go to right window")

-- Tabs
map("<leader>to", ":tabnew<CR>", "Open new tab")
map("<leader>tx", ":tabclose<CR>", "Close current tab")
map("<leader>tn", ":tabn<CR>", "Go to next tab")
map("<leader>tp", ":tabp<CR>", "Go to previous tab")

-- Toggle line wrapping
map("<leader>lw", "<cmd>set wrap!<CR>", "Toggle line wrapping")

-- Stay in indent mode
map("<", "<gv", "Indent to the left", "v")
map(">", ">gv", "Indent to the right", "v")

-- Diagnostic keymaps
map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
map("]d", vim.diagnostic.goto_next, "Go to next diagnostic message")
map("<leader>d", vim.diagnostic.open_float, "Open floating diagnostic message")
map("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")

-- line numbers
map("<leader>n", "<cmd>set nu!<CR>", "toggle line number")
map("<leader>rn", "<cmd>set rnu!<CR>", "toggle relative number")

-- folding
local function toggle_foldcolumn()
    if vim.o.foldcolumn == "0" then
        vim.o.foldcolumn = "1"
    else
        vim.o.foldcolumn = "0"
    end
end

map('zo', 'za', "Toggle fold")
map('zi', toggle_foldcolumn, "ToggleFold")
