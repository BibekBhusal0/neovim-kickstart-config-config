local wrap_keys = require "utils.wrap_keys"

vim.g.nvim_surround_no_mappings = true
return {
  {
    "kylechui/nvim-surround",
    keys = wrap_keys {
      { "gs", "<Plug>(nvim-surround-normal)", desc = "Add surrounding around motion" },
      { "gss", "<Plug>(nvim-surround-normal-cur)", desc = "Add surrounding around current line" },
      {
        "gS",
        "<Plug>(nvim-surround-normal-line)",
        desc = "Add surrounding around motion on new lines",
      },
      {
        "gSS",
        "<Plug>(nvim-surround-normal-cur-line)",
        desc = "Add surrounding around current line on new lines",
      },
      {
        "gs",
        "<Plug>(nvim-surround-visual)",
        mode = "x",
        desc = "Add surrounding around visual selection",
      },
      {
        "gS",
        "<Plug>(nvim-surround-visual-line)",
        mode = "x",
        desc = "Add surrounding around visual selection on new lines",
      },
      { "ds", "<Plug>(nvim-surround-delete)", desc = "Delete surrounding" },
      { "cs", "<Plug>(nvim-surround-change)", desc = "Change surrounding" },
      { "cS", "<Plug>(nvim-surround-change-line)", desc = "Change surrounding on new lines" },
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

  {
    "nemanjamalesija/smart-paste.nvim",
    config = true,
    keys = {
      { "{", mode = { "n", "x" } },
      { "p", mode = { "n", "x" } },
      { "P", mode = { "n", "x" } },
      { "]p", mode = { "n", "x" } },
      { "]P", mode = { "n", "x" } },
      {
        "<leader>p",
        function()
          require("smart-paste").paste { register = "+", key = "p" }
        end,
        desc = "Paste from system clipboard",
        mode = { "n", "x" },
      },
      {
        "<leader>]p",
        function()
          require("smart-paste").paste { register = "+", key = "]p" }
        end,
        desc = "Paste below from system clipboard",
        mode = { "n", "x" },
      },
      {
        "<leader>[p",
        function()
          require("smart-paste").paste { register = "+", key = "[p" }
        end,
        desc = "Paste above from system clipboard",
        mode = { "n", "x" },
      },
    },
  },
}
