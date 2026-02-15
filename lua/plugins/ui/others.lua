local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      indent = { char = "▏" },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "alpha",
        },
      },
    },
  }, -- Better indentations

  {
    "kevinhwang91/nvim-hlslens",
    keys = { "n", "N", "*", "#", "g*", "g#" },
    config = function()
      require("hlslens").setup { nearest_only = true, calm_down = true }
      local cmd = ":lua require('hlslens').start()<CR>"
      map("n", ":execute('normal! ' . v:count1 . 'n')<CR>zz" .. cmd, "Next Search")
      map("N", ":execute('normal! ' . v:count1 . 'N')<CR>zz" .. cmd, "Previous Search")
      map("*", "*zz" .. cmd, "Next Search")
      map("#", "#zz" .. cmd, "Previous Search")
      map("g*", "g*zz" .. cmd, "Next Search")
      map("g#", "g#zz" .. cmd, "Previous Search")
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      handle = { blend = 0 },
      marks = { Cursor = { color = "#00ff00" } },
      show_in_active_only = true,
      hide_if_all_visible = true,
      handlers = { gitsigns = true },
    },
  }, -- scrollbar showing gitsigns and diagnostics

  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = wrap_keys { { "<leader>TT", ":Twilight<CR>", desc = "Toggle Twilight" } },
    opts = { context = 10 },
  }, -- dim inactive code

  {
    "aikhe/wrapped.nvim",
    dependencies = { "nvzone/volt", "nvim-lua/plenary.nvim" },
    cmd = { "NvimWrapped" },
    opts = {},
  },
}
