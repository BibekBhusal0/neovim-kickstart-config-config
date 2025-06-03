local wrap_keys = require "utils.wrap_keys"
return {
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    -- event = "VeryLazy",
  }, -- Hints keybinds

  {
    "smartinellimarco/nvcheatsheet.nvim",
    lazy = true,
    keys = wrap_keys {
      {
        "<leader>CH",
        ':lua require("nvcheatsheet").toggle()<CR>',
        desc = "Toggle Cheatsheet",
      },
    },
    config = function()
      require("nvcheatsheet").setup(require "utils.cheatsheet")
    end,
  }, --  cheatsheet

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
    "m4xshen/hardtime.nvim",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    keys = wrap_keys { { "<leader>th", ":Hardtime toggle<CR>", desc = "Toggle Hardtime" } },
    config = function()
      require("hardtime").setup {
        restriction_mode = "hint",
        disabled_keys = {
          ["<Up>"] = {},
          ["<Down>"] = {},
          ["<Left>"] = {},
          ["<Right>"] = {},
        },
        disable_mouse = false,
        disabled_filetypes = vim.tbl_deep_extend(
          "force",
          require("hardtime.config").config.disabled_filetypes,
          { "mcphub", "codecompanion" }
        ),
      }
    end,
  },

  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    keys = wrap_keys {
      {
        "<leader>tk",
        function()
          require "utils.input" ("Key", function(text)
            vim.cmd("KeyAnalyzer " .. text)
          end, "<leader>", 22, "   ")
        end,
        desc = "Key Analyzer",
      },
    },
    opts = {},
  },
}
