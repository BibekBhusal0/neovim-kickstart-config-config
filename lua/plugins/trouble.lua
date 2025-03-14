local map = require 'utils.map'

map('<leader>cn', ':cnext<cr>', 'QuickFix Next')
map('<leader>cp', ':cprevious<cr>', 'QuickFix Previous')
map('<leader>c[', ':cfirst<cr>', 'QuickFix First')
map('<leader>c]', ':clast<cr>', 'QuickFix Last')

return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    { '<leader>cE', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Trouble Diagnostics Toggle Buffer' },
    { '<leader>ce', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Trouble Diagnostics Toggle' },
    { '<leader>cL', '<cmd>Trouble loclist toggle<cr>', desc = 'Trouble LocList Toggle' },
    { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'Trouble LSP Toggle' },
    { '<leader>cq', '<cmd>Trouble qflist toggle<cr>', desc = 'Trouble Quickfix Toggle' },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Trouble Symbols Toggle' },
    { '<leader>ct', '<cmd>Trouble toggle<cr>', desc = 'Trouble  Toggle' },
  },
}
