local wrap_keys = require "utils.wrap_keys"

return {
  "ThePrimeagen/refactoring.nvim",
  opts = {},
  keys = wrap_keys {
    {
      "<leader>re",
      function()
        return require("refactoring").refactor "Extract Function"
      end,
      desc = "Refactor Extract Function",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rf",
      function()
        return require("refactoring").refactor "Extract Function To File"
      end,
      desc = "Refactor Extract Function To File",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rv",
      function()
        return require("refactoring").refactor "Extract Variable"
      end,
      desc = "Refactor Extract Variable",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rI",
      function()
        return require("refactoring").refactor "Inline Function"
      end,
      desc = "Refactor Inline Function",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>ri",
      function()
        return require("refactoring").refactor "Inline Variable"
      end,
      desc = "Refactor Inline Variable",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rbb",
      function()
        return require("refactoring").refactor "Extract Block"
      end,
      desc = "Refactor Extract Block",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rbf",
      function()
        return require("refactoring").refactor "Extract Block To File"
      end,
      desc = "Refactor Extract Block To File",
      mode = { "n", "x" },
      expr = true,
    },

    {
      "<leader>rt",
      ":lua require('telescope').extensions.refactoring.refactors()<CR>",
      desc = "Refactor Telescope",
      mode = { "n", "x" },
    },

    {
      "<leader>rp",
      ":lua require('refactoring').debug.print_var()<CR>",
      desc = "Refactor Print Var",
      mode = { "n", "x" },
    },

    {
      "<leader>rP",
      ":lua require('refactoring').debug.cleanup()<CR>",
      desc = "Refactor Cleanup",
      mode = { "n", "x" },
    },

    {
      "<leader>ro",
      ":lua require('refactoring').debug.printf()<CR>",
      desc = "Refactor Printf",
      mode = { "n", "x" },
    },
  },
}
