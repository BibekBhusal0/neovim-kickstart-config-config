local wrap_keys = require "utils.wrap_keys"

return {
  "tsakirist/telescope-lazy.nvim",
  keys = wrap_keys { { "<leader>fl", ":Telescope lazy<CR>", desc = "Find Lazy Plugins Doc" } },
}
