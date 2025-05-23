local wrap_keys = require "utils.wrap_keys"

return {
  "zongben/proot.nvim",
  opts = {},
  keys = wrap_keys { { "<Leader>fp", ":Proot<CR>", desc = "Find Directories" } },
  cmd = { "Proot" },
}
