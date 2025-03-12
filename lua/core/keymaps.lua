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
map('<C-O>', '<Esc>o', 'Move to New Line', 'i')
map('<C-]>', '<Esc>ldbi', 'Delete Word', 'i')

map('<C-s>', ': w <CR>', 'Save File')

-- quit
map('<leader>sn', ':noautocmd w <CR>', 'Save File Without formatting')
map('<C-q>', ': q!<CR>', 'Quit File')
map('<leader>xx', ': q <CR>', 'Quit File')
map('<leader>xX', ': q!<CR>', 'Quit File force')
map('<leader>xa', ':qa<CR>', 'Quit all Files')
map('<leader>xA', ':qa!<CR>', 'Quit all Files force')
map('<leader>xt', ':tabclose<CR>', 'Quit Tab')
map('<leader>xs', ':close<CR>', 'Quit Split')

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
map('[d', vim.diagnostic.goto_prev, 'Diagnostic previous')
map(']d', vim.diagnostic.goto_next, 'Diagnostic next')
map('<leader>dd', vim.diagnostic.open_float, 'Diagnostic floating')

-- line numbers
map('<leader>nn', ':set nu!<CR>', 'Toggle Line Number')
map('<leader>rn', ':set rnu!<CR>', 'Toggle Relative Line Number')

-- folding
local function toggle_foldcolumn()
  if vim.o.foldcolumn == '0' then
    vim.o.foldcolumn = '1'
  else
    vim.o.foldcolumn = '0'
  end
end

map('zo', 'za', 'Toggle fold')
map('<leader>zi', toggle_foldcolumn, 'Toggle fold column')
map('<Esc>', '<Cmd>noh<CR>', 'Clear Highlight')
