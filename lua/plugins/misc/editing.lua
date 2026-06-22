local wrap_keys = require "utils.wrap_keys"

return {
  {
    "kylechui/nvim-surround",
    keys = {
      { "ys", mode = { "n", "o", "x" }, desc = "Surround Text" },
      { "ds", mode = { "n", "o", "x" }, desc = "Surround Delete" },
      { "cs", mode = { "n", "o", "x" }, desc = "Surround Change" },
    },
    opts = {},
  }, -- change brackets, quotes and surrounds

  {
    "windwp/nvim-autopairs",
    keys = {
      { "{", mode = { "i" } },
      { "[", mode = { "i" } },
      { "(", mode = { "i" } },
      { '"', mode = { "i" } },
      { "'", mode = { "i" } },
      { "`", mode = { "i" } },
      { "}", mode = { "i" } },
      { "]", mode = { "i" } },
      { ")", mode = { "i" } },
    },
    opts = { fast_wrap = { map = "<A-e>", manual_position = false } },
  }, -- Autoclose parentheses, brackets, quotes, etc. also work on command mode,

  {
    "Wansmer/treesj",
    keys = wrap_keys {
      { "gi", ":TSJToggle<CR>", desc = "Toggle split object under cursor" },
      { "gj", ":TSJJoin<CR>", desc = "Join the object under cursor" },
      { "gk", ":TSJSplit<CR>", desc = "Split the object under cursor" },
    },
    opts = { use_default_keymaps = false, max_join_length = 10000 },
  }, -- advanced join and split

  {
    "johmsalas/text-case.nvim",
    opts = {},
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },

  {
    "piersolenski/import.nvim",
    opts = { picker = "telescope" },
    cmd = { "Import" },
    keys = wrap_keys { { "<leader>fi", ":Import<CR>", desc = "Import" } },
  },
}
