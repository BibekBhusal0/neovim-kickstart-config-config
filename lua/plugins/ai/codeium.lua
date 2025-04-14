local map = require 'utils.map'
local wrap_keys = require 'utils.wrap_keys'

return {
  'monkoose/neocodeium',
  cmd = { 'NeoCodeium' },

  keys = wrap_keys {
    { '<leader>a<leader>', ':NeoCodeium enable<CR>', desc = 'Codeium Start' },
    { '<leader>aT', ':lua require"neocodeium.commands".toggle(true)<CR>', desc = 'Codeium Toggle' },
    { '<leader>aC', ':NeoCodeium chat<CR>', desc = 'Codeium Chat' },
    { '<leader>ar', ':NeoCodeium restart<CR>', desc = 'Codeium Restart' },
    { '<leader>ab', ':NeoCodeium toggle_buffer<CR>', desc = 'Codeium Toggle Buffer' },
  },

  config = function()
    local neocodeium = require 'neocodeium'
    neocodeium.setup {
      enabled = true,
      filetypes = {
        codecompanion = false,
        quickrun = false,
        trouble = false,
        qf = false,
        noice = false,
      },
    }

    map('<A-f>', neocodeium.accept, 'Codeium Accept', 'i')
    map('<A-w>', neocodeium.accept_word, 'Codeium Accept Word', 'i')
    map('<A-a>', neocodeium.accept_line, 'Codeium Accept Line', 'i')
    map('<A-e>', function()
      neocodeium.cycle_or_complete(-1)
    end, 'Codeium Next Autocomplete', 'i')
    map('<A-r>', function()
      neocodeium.cycle_or_complete(1)
    end, 'Codeium Previous Autocomplete', 'i')
    map('<A-c>', neocodeium.clear, 'Codeium Clear', 'i')
  end,
}
