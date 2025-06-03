local wrap_keys = require "utils.wrap_keys"

return {
  "debugloop/telescope-undo.nvim",
  keys = wrap_keys {
    { "<leader>U", ":Telescope undo<CR>", desc = "Telescope Undo" },
    { "<leader>fu", ":Telescope undo<CR>", desc = "Telescope undo" },
  },
  cmd = { "Telescope undo" },

  config = function()
    require("telescope").setup {
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    }
    require("telescope").load_extension "undo"
  end,
}
