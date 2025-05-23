local wrap_keys = require "utils.wrap_keys"

return {
  "debugloop/telescope-undo.nvim",
  keys = wrap_keys { { "<leader>U", ":Telescope undo<CR>", desc = "Undo Tree" } },
  cmd = { "Telescope undo" },
}
