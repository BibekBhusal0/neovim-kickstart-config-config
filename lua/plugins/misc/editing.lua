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
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup { fast_wrap = { map = "<A-e>", manual_position = false } }
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp = require "cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
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
    "mg979/vim-visual-multi",
    keys = { "<C-n>", "<C-Up>", "<C-Down>", "<S-Left>", "<S-Right>" },
  }, -- multi line editing

  {
    "nguyenvukhang/nvim-toggler",
    keys = wrap_keys {
      { "gt", ':lua require("nvim-toggler").toggle() <CR>', desc = "Toggle Value" },
    },
    opts = {
      inverses = {
        ["neo-vim"] = "vs-code",
        ["0"] = "1",
        show = "hide",
        best = "worst",
        pre_defer = "post_defer",
      },
      remove_default_keybinds = true,
    },
  }, -- Toggle between true and false ; more

  {
    "johmsalas/text-case.nvim",
    opts = {},
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },

  {
    "y3owk1n/time-machine.nvim",
    cmd = { "TimeMachineToggle", "TimeMachinePurgeBuffer", "TimeMachinePurgeAll" },
    opts = {
      split_opts = { width = 30 },
      float_opts = { winblend = 1 },
    },
    version = "*",
    keys = wrap_keys {
      { "<leader>tm", ":TimeMachineToggle<CR>", desc = "Time Machine Toggle Tree" },
      { "<leader>tM", ":TimeMachinePurgeBuffer<CR>", desc = "Time Machine Purge current" },
      { "<leader>tX", ":TimeMachinePurgeAll<CR>", desc = "Time Machine Purge all" },
      { "<leader>u", ":TimeMachineToggle<CR>", desc = "Time Machine Toggle Tree" },
    },
  }, -- similar to undo tree

  {
    "piersolenski/import.nvim",
    opts = { picker = "telescope" },
    cmd = { "Import" },
    keys = wrap_keys { { "<leader>fi", ":Import<CR>", desc = "Import" } },
  },
}
