local wrap_keys = require "utils.wrap_keys"

local summary = ':lua require("neotest").summary.open()<CR>'
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
    {
      "<leader>Ta",
      ':lua require("neotest").run.run(vim.fn.getcwd()) <CR>' .. summary,
      desc = "Test Run All",
    },
    {
      "<leader>Td",
      ':lua require("neotest").run.run({strategy = "dap"})<CR>',
      desc = "Test Debug",
    },
    {
      "<leader>TR",
      ':lua require("neotest").run.run()<CR>' .. summary,
      desc = "Test Run",
    },
    {
      "<leader>Tr",
      ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>' .. summary,
      desc = "Test Run File",
    },
    { "<leader>TS", ':lua require("neotest").run.stop()<CR>', desc = "Test Stop" },
    { "<leader>To", ':lua require("neotest").output.open()<CR>', desc = "Test Ouput" },
    { "<leader>Tp", ':lua require("neotest").output_panel.toggle()<CR>', desc = "Test Panel" },
    { "<leader>Ts", ':lua require("neotest").summary.toggle()<CR>', desc = "Test Summary" },
    {
      "<leader>Tw",
      ':lua require("neotest").watch.toggle()<CR>' .. summary,
      desc = "Test Watch Toggle",
    },
    {
      "<leader>TW",
      ':lua require("neotest").watch.toggle(vim.fn.getcwd())<CR>' .. summary,
      desc = "Test Watch Toggle All",
    },
  },

  config = function()
    require("neotest").setup {
      adapters = { require "neotest-bun" },
      floating = { border = "rounded" },
      output = { open_on_run = false },
      summary = { open = "botright vsplit | vertical resize 30" },
    }
  end,
}
