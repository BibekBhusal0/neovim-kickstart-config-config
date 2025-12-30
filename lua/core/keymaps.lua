local map = require "utils.map"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<ESC>", "Normal Mode", "v")

-- navigation in insert mode
map("<A-h>", "<ESC>^i", "Move to Begining of line", "i")
map("<A-l>", "<End>", "Move to End of line", "i")
map("<C-h>", "<Left>", "Move left", "i")
map("<C-l>", "<Right>", "Move right", "i")
map("<C-j>", "<Down>", "Move down", "i")
map("<C-k>", "<Up>", "Move up", "i")
map("jj", "<ESC>", "Normal Mode", "i")
map("<C-c>", "<Esc>", "Normal Mode", "i")
map("<C-o>", "<Esc>o", "Move to New Line", "i")
map("<C-]>", "<Esc>ldbi", "Delete Word", "i")
map("<leader>i", "`^", "Goto Last Insert")

-- simple keymaps
map("H", "_", "Start of line")
map("L", "$", "End of line")
map("g,", "<cmd>norm A,<CR>", "Append a comma")
map("g.", "<cmd>norm A.<CR>", "Append a period")
map("g;", "<cmd>norm A;<CR>", "APPEND a simiconlan")

-- Opening file explorer
map("<leader>O", ':silent !nautilus "%:p:h" &<CR>', "Open Explorer (current file)")
map("<leader>P", function()
  vim.cmd('silent !nautilus "' .. vim.fn.getcwd() .. '" &')
end, "Open Explorer(current directory)")

-- Move and duplicate lines
map("K", ":m '<-2<CR>gv=gv", "Move Lines Up", "v")
map("J", ":m '>+1<CR>gv=gv", "Move Lines Down", "v")
map("<C-A-j>", ":copy '<-1<CR>gv=gv", "Duplicate Lines Below", "v")
map("<C-A-k>", ":copy '><CR>gv=gv", "Duplicate Lines Above", "v")
map("<C-A-k>", ":copy .-1<CR>", "Duplicate Line Above")
map("<C-A-j>", ":copy .<CR>", "Duplicate Line Below")
map("K", "<cmd>m .-2<CR>==", "Move Line Up")
map("J", "<cmd>m .+1<CR>==", "Move Line Down")

-- quit
map("<leader>sn", ":noautocmd w <CR>", "Save File Without formatting")
map("<leader>xx", ": q <CR>", "Quit File")
map("<leader>xX", ": q!<CR>", "Quit File force")
map("<leader>xa", ":qa<CR>", "Quit all Files")
map("<leader>xA", ":qa!<CR>", "Quit all Files force")
map("<leader>xt", ":tabclose<CR>", "Quit Tab")
map("<leader>xs", ":wincmd q<CR>", "Quit Split")

-- center while navigation
map("<C-d>", "<C-d>zz", "Scroll down")
map("<C-u>", "<C-u>zz", "Scroll up")

-- copy/paste to
-- system clipboard with leader y
map("<leader>y", '"+y', "Yank to system clipboard", { "n", "v" })
map("<leader>Y", '"+Y', "Yank line to system clipboard", { "n", "v" })

-- paste from system clipboard
map("<C-v>", '"+p', "Paste From System Clipboard", { "n", "v" })
map("<C-v>", "<MiddleMouse>", "Paste From System Clipboard", "i")

-- yank all
map("<leader>k", "ggVGy", "Yank all")
map("<leader>K", 'ggVG"+y', "Yank all to System Clipboard")

map("p", [["_dP]], "paste", "x")

-- select all
map("<A-a>", "ggVG", "Select all")

-- use black hole register
map("zc", '"_c', "Change to black hole register", { "n", "v" })
map("zd", '"_d', "Delete to black hole register", { "n", "v" })
map("zy", '"_y', "Yank to black hole register", { "n", "v" })
map("zx", '"_x', "Cut to black hole register", { "n", "v" })
map("zp", '"_dP', "Paste without yanking", "x")

-- terminal
map("<C-x>", "<C-\\><C-N>", "terminal escape terminal mode", "t")

-- Toggle line wrapping
map("<leader>lW", ":set wrap!<CR>", "Toggle line wrapping")

-- Stay in indent mode
map("<", "<gv", "Indent left", "v")
map(">", ">gv", "Indent right", "v")

-- line numbers
map("<leader>nn", ":set nu!<CR>", "Toggle Line Number")
map("<leader>rn", ":set rnu!<CR>", "Toggle Relative Line Number")

map("zo", "za", "Toggle fold")
map("<Esc>", ":noh<CR>", "Clear Highlight")

local function toggle_statusline()
  local current_status = vim.o.laststatus
  if current_status == 2 then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 2
  end
end

local function toggle_tabline()
  local current_tabline = vim.o.showtabline
  if current_tabline == 2 then
    vim.o.showtabline = 0
  else
    vim.o.showtabline = 2
  end
end

map("<leader>ll", toggle_statusline, "Toggle Status Line")
map("<leader>bl", toggle_tabline, "Toggle Tab Line")

-- Diagnostic keymaps
map("<leader>dd", vim.diagnostic.open_float, "Diagnostic floating")
map("<leader>]d", function () vim.diagnostic.goto_next{ float = false } end, "Jump next Diagnostic")
map("<leader>[d", function () vim.diagnostic.goto_prev{ float = false } end, "Jump Previous Diagnostic")

local function toggle_virtual_lines()
  local current_config = vim.diagnostic.config()
  if current_config == nil then
    return
  end
  local is_currently_enabled = current_config.underline == true
  local new_state_enabled = not is_currently_enabled
  local new_underline_state = new_state_enabled
  local new_virtual_lines_state = new_state_enabled and { current_line = true } or false
  vim.diagnostic.config {
    virtual_lines = new_virtual_lines_state,
    underline = new_underline_state,
  }
end

map("<leader>dt", toggle_virtual_lines, "Toggle diagnostic virtual lines")
