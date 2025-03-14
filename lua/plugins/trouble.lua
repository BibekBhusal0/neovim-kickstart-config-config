local map = require 'utils.map'

map('<leader>cj', ':cnext<cr>', 'QuickFix Next')
map('<leader>ck', ':cprevious<cr>', 'QuickFix Previous')
map('<leader>c[', ':cfirst<cr>', 'QuickFix First')
map('<leader>c]', ':clast<cr>', 'QuickFix Last')

return {
  'folke/trouble.nvim',
  config = function()
    local trouble = require 'trouble'
    trouble.setup()
    map('<leader>cl', function()
      trouble.next { skip_groups = true, jump = true }
    end, 'Trouble next')
    map('<leader>ch', function()
      trouble.prev { jump = true }
    end, 'Trouble prev')
  end,
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
