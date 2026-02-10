local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

return {
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    keys = wrap_keys {
      { "<leader>lm", ":lua require('nvim-navbuddy').open()<CR>", desc = "Open Navbuddy" },
    },
    config = function()
      local navbuddy = require "nvim-navbuddy"
      local icons = require("utils.icons").get_padded_icon "symbols"
      navbuddy.setup {
        lsp = { auto_attach = true },
        icons = icons,
      }
    end,
  }, -- Easy navigation within lsp Symbols

  {
    "Zeioth/garbage-day.nvim",
    event = "LspAttach",
    opts = {},
  }, -- Free up resources by stooping unused LSP clients

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require("tiny-inline-diagnostic").setup {
        preset = "ghost",
        transparent_bg = false,
        options = {
          throttle = 200,
          show_source = { enabled = false },
          add_messages = { display_count = true, show_multiple_glyphs = false },
          multilines = { enabled = true },
          break_line = { enabled = true, after = 40 },
          enable_on_select = false,
        },
      }
      vim.diagnostic.config {
        virtual_text = false,
        signs = false,
        underline = true,
      }
      map("<leader>dt", ":TinyInlineDiag toggle<cr>", "Toggle Diagnostic")
    end,
  }, -- Better diagnostic messages

  { "antosha417/nvim-lsp-file-operations", lazy = true },

  {
    "folke/lazydev.nvim",
    enabled = true,
    opts = { library = {} },
    ft = { "lua" },
  },
}
