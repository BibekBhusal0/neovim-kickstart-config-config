-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set

-- navigation in insert mode
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
map("i", "jj", "<ESC>")
map("i", "<C-c>", "<Esc>")
map("i", "<C-O>", "<Esc>o", { desc = "move to new line" })
map("i", "<C-]>", "<Esc>ldbi", { desc = "delete word" })

-- Disable the spacebar key's default behavior in Normal and Visual modes
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
map("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
map("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
map("n", "<C-q>", "<cmd> q <CR>", opts)

-- https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
-- move liens in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- copy/paste to system clipboard with leader y
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)
map('x', '<leader>p', [["_dP]], opts)

-- Vertical scroll and center
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Resize with arrows
map("n", "<Up>", ":resize -2<CR>", opts)
map("n", "<Down>", ":resize +2<CR>", opts)
map("n", "<Left>", ":vertical resize -2<CR>", opts)
map("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "<leader>x", ":bdelete!<CR>", opts)   -- close buffer
map("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
map("n", "<leader>v", "<C-w>v", opts)      -- split window vertically
map("n", "<leader>h", "<C-w>s", opts)      -- split window horizontally
map("n", "<leader>se", "<C-w>=", opts)     -- make split windows equal width & height
map("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
map("n", "<C-k>", ":wincmd k<CR>", opts)
map("n", "<C-j>", ":wincmd j<CR>", opts)
map("n", "<C-h>", ":wincmd h<CR>", opts)
map("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
map("n", "<leader>to", ":tabnew<CR>", opts)   -- open new tab
map("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
map("n", "<leader>tn", ":tabn<CR>", opts)     --  go to next tab
map("n", "<leader>tp", ":tabp<CR>", opts)     --  go to previous tab

-- Toggle line wrapping
map("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yanked when pasting
map("v", "p", "'_dP", opts)

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- folding 
map('n', 'zo', 'za')

local function toggle_foldcolumn()
    if vim.o.foldcolumn == "0" then
        vim.o.foldcolumn = "1"  
    else
        vim.o.foldcolumn = "0" 
    end
end

vim.keymap.set('n', 'zi', toggle_foldcolumn, { noremap = true, silent = true , desc = "ToggleFold"})
