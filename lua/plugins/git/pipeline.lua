local wrap_keys = require "utils.wrap_keys"

return {
  {
    "topaxi/pipeline.nvim",
    keys = wrap_keys {
      { "<leader>ci", "<cmd>Pipeline<cr>", desc = "Open pipeline.nvim" },
    },
    opts = {},
  },
}
