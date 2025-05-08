local wrap_keys = require "utils.wrap_keys"
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",

    -- adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
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
    { "<leader>Ts", ':lua require("neotest").run.stop()<CR>', desc = "Test Stop" },
    { "<leader>To", ':lua require("neotest").output.open()<CR>', desc = "Test Ouput" },
    { "<leader>Tp", ':lua require("neotest").output_panel.toggle()<CR>', desc = "Test Panel" },
    { "<leader>Tv", ':lua require("neotest").summary.toggle()<CR>', desc = "Test Summary" },
  },

  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG" },
          runner = "pytest",
          python = "python",
          pytest_discover_instances = true,
        },

        require "neotest-jest" {
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    }
  end,
}
