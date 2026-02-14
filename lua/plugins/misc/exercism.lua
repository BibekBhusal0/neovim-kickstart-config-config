local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

return {
  "2kabhishek/exercism.nvim",
  cmd = { "Exercism" },
  keys = wrap_keys {
    { "<leader>xl", ":Exercism list<Cr>", desc = "Exercism List" },
    { "<leader>xr", ":Exercism recents<Cr>", desc = "Exercism Recents" },
    { "<leader>xL", ":Exercism languages<Cr>", desc = "Exercism Language" },
  },
  dependencies = {
    "2kabhishek/utils.nvim",
    "nvim-telescope/telescope.nvim",
    "2kabhishek/termim.nvim",
  },
  config = function()
    require("exercism").setup {
      default_language = "bash",
      add_default_keybindings = false,
    }
    map("<leader>sX", ":Exercism submit<Cr>", "Exercism Submit")
    map("<leader>sx", ":Exercism test<Cr>", "Exercism Test")
  end,
}
