local wrap_keys = require "utils.wrap_keys"

return {
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    opts = {
      preset = "helix",
      win = { padding = { 0, 0 }, title_pos = "right" },
    },
    event = "VeryLazy",
  }, -- Hints keybinds

  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    keys = wrap_keys { { "<leader>sk", ":ShowkeysToggle<CR>", desc = "Toggle Showkeys" } },
    opts = {
      timeout = 1,
      maxkeys = 5,
      show_count = true,
      position = "top-center",
      height = 3,
      excluded_modes = { "i" },
      keyformat = { ["<C>"] = "󰘳" },
    },
  },

  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    keys = wrap_keys {
      {
        "<leader>tk",
        function()
          require "utils.input"("Key", function(text)
            vim.cmd("KeyAnalyzer " .. text)
          end, "<leader>", 22, "   ")
        end,
        desc = "Key Analyzer",
      },
    },
    opts = {},
  },
}
