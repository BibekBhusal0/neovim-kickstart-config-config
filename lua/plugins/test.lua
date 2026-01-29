local wrap_keys = require "utils.wrap_keys"
-- TODO: Needs Test are not tested needs testings

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",

    -- adapters
    "arthur944/neotest-bun",
  },

  keys = wrap_keys {
    { "<leader>Ta", ':lua require("neotest").run.attach()<CR>', desc = "Test Attach" },
    {
      "<leader>Td",
      ':lua require("neotest").run.run({strategy = "dap"})<CR>',
      desc = "Test Debug",
    },
    { "<leader>Tr", ':lua require("neotest").run.run()<CR>', desc = "Test Run" },
    {
      "<leader>TR",
      ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
      desc = "Test Run File",
    },
    { "<leader>TS", ':lua require("neotest").run.stop()<CR>', desc = "Test Stop" },
    { "<leader>To", ':lua require("neotest").output.open()<CR>', desc = "Test Ouput" },
    { "<leader>Tp", ':lua require("neotest").output_panel.toggle()<CR>', desc = "Test Panel" },
    { "<leader>Ts", ':lua require("neotest").summary.toggle()<CR>', desc = "Test Summary" },
  },

  config = function()
    require("neotest").setup {
      adapters = { require "neotest-bun" },
    }
  end,
}
