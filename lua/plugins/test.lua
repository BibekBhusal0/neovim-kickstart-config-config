local wrap_keys = require 'utils.wrap_keys'
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'MarkEmmons/neotest-deno',

    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
  },

  keys = wrap_keys {
    { '<leader>Ta', ':lua require("neotest").run.attach()<CR>', desc = 'Test Attach' },
    { '<leader>Td', ':lua require("neotest").run.run({strategy = "dap"})<CR>', desc = 'Test Debug' },
    { '<leader>Tr', ':lua require("neotest").run.run()<CR>', desc = 'Test Run' },
    { '<leader>TR', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', desc = 'Test Run File' },
    { '<leader>Ts', ':lua require("neotest").run.stop()<CR>', desc = 'Test Stop' },
  },

  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python',
        require 'neotest-deno',
        require 'neotest-jest',
      },
    }
  end,
}
