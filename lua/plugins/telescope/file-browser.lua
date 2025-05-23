local wrap_keys = require "utils.wrap_keys"

return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = wrap_keys {
    { "<leader>fo", ":Telescope file_browser<CR>", desc = "Telescope file browser" },
    {
      "<leader>fJ",
      ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
      desc = "Telescope file browser crr",
    },
  },
}
