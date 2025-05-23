local wrap_keys = require "utils.wrap_keys"

return {
  "fredehoey/tardis.nvim",
  opts = {
    next = "<C-S-j>",
    prev = "<C-S-K>",
  },
  keys = wrap_keys { { "<leader>gg", ":Tardis git<CR>", desc = "Git Time Travel" } },
}
