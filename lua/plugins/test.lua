return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'MarkEmmons/neotest-deno',

    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
  },

  keys = {
    { '<leader>Ta', ':lua require("neotest").run.attach()<cr>', desc = 'Test Attach' },
    { '<leader>Td', ':lua require("neotest").run.run({strategy = "dap"})<cr>', desc = 'Test Debug' },
    { '<leader>Tr', ':lua require("neotest").run.run()<cr>', desc = 'Test Run' },
    { '<leader>TR', ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', desc = 'Test Run File' },
    { '<leader>Ts', ':lua require("neotest").run.stop()<cr>', desc = 'Test Stop' },
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
