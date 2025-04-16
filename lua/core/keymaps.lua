local map = require 'utils.map'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map('n', '<ESC>', 'Normal Mode', 'v')

-- navigation in insert mode
map('<C-b>', '<ESC>^i', 'Move to Begining of line', 'i')
map('<C-e>', '<End>', 'Move to End of line', 'i')
map('<C-h>', '<Left>', 'Move left', 'i')
map('<C-l>', '<Right>', 'Move right', 'i')
map('<C-j>', '<Down>', 'Move down', 'i')
map('<C-k>', '<Up>', 'Move up', 'i')
map('jj', '<ESC>', 'Normal Mode', 'i')
map('<C-c>', '<Esc>', 'Normal Mode', 'i')
map('<C-o>', '<Esc>o', 'Move to New Line', 'i')
map('<C-]>', '<Esc>ldbi', 'Delete Word', 'i')

map('<C-s>', ': w <CR>', 'Save File')

-- Move and duplicate lines
map('K', ":m '<-2<CR>gv=gv", 'Move Lines Up', 'v')
map('J', ":m '>+1<CR>gv=gv", 'Move Lines Down', 'v')
map('<C-A-j>', ":copy '<-1<CR>gv=gv", 'Duplicate Lines Below', 'v')
map('<C-A-k>', ":copy '><CR>gv=gv", 'Duplicate Lines Above', 'v')
map('<C-A-k>', ':copy .-1<CR>', 'Duplicate Line Above')
map('<C-A-j>', ':copy .<CR>', 'Duplicate Line Below')
map('K', ':m .-2<CR>==', 'Move Line Up')
map('J', ':m .+1<CR>==', 'Move Line Down')

-- quit
map('<leader>sn', ':noautocmd w <CR>', 'Save File Without formatting')
map('<leader>xx', ': q <CR>', 'Quit File')
map('<leader>xX', ': q!<CR>', 'Quit File force')
map('<leader>xa', ':qa<CR>', 'Quit all Files')
map('<leader>xA', ':qa!<CR>', 'Quit all Files force')
map('<leader>xt', ':tabclose<CR>', 'Quit Tab')
map('<leader>xs', ':close<CR>', 'Quit Split')

-- center while navigation
map('N', 'Nzzzv', 'Previous and center')
map('n', 'nzzzv', 'next and center')
map('<C-d>', '<C-d>zz', 'Scroll down')
map('<C-u>', '<C-u>zz', 'Scroll up')

-- copy/paste to
-- system clipboard with leader y
map('<leader>y', '"+y', 'Yank to system clipboard', { 'n', 'v' })
map('<leader>Y', '"+Y', 'Yank line to system clipboard')

-- yank all
map('<leader>k', 'ggVGy', 'Yank all')
map('<leader>K', 'ggVG"+y', 'Yank all to System Clipboard')

-- select all
map('<C-a>', 'ggVG', 'Yank all')

-- use black hole register
map('zc', '"_c', 'Change to black hole register', { 'n', 'v' })
map('zd', '"_d', 'Delete to black hole register', { 'n', 'v' })
map('zy', '"_y', 'Yank to black hole register', { 'n', 'v' })
map('zx', '"_x', 'Cut to black hole register', { 'n', 'v' })
map('zp', '"_dP', 'Paste without yanking', 'x')

-- terminal
map('<C-x>', '<C-\\><C-N>', 'terminal escape terminal mode', 't')

-- Toggle line wrapping
map('<leader>lW', ':set wrap!<CR>', 'Toggle line wrapping')

-- Stay in indent mode
map('<', '<gv', 'Indent left', 'v')
map('>', '>gv', 'Indent right', 'v')

-- Diagnostic keymaps
map('<leader>dd', vim.diagnostic.open_float, 'Diagnostic floating')

-- line numbers
map('<leader>nn', ':set nu!<CR>', 'Toggle Line Number')
map('<leader>rn', ':set rnu!<CR>', 'Toggle Relative Line Number')

map('zo', 'za', 'Toggle fold')
map('<Esc>', ':noh<CR>', 'Clear Highlight')

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

map('<leader>ll', toggle_statusline, 'Toggle Status Line')
map('<leader>bl', toggle_tabline, 'Toggle Tab Line')
