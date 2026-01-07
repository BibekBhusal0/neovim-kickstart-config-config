local wrap_keys = require "utils.wrap_keys"

return {
  "fredehoey/tardis.nvim",
  enabled = true,
  cmd = { "Tardis" },
  opts = {
    next = "<C-S-j>",
    prev = "<C-S-K>",
  },
  keys = wrap_keys { { "<leader>Gg", ":Tardis git<CR>", desc = "Git Time Travel" } },
}
