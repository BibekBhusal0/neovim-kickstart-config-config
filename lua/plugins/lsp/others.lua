local map = require "utils.map"

return {
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
