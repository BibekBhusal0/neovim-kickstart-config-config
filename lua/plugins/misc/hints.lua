return { -- hints, will remove soon
  {
    'folke/which-key.nvim',
    cmd = 'WhichKey',
    -- keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    -- event = "VeryLazy",
  }, -- Hints keybinds

  {
    'smartinellimarco/nvcheatsheet.nvim',
    lazy = true,
    keys = { { '<leader>ch', ':lua require("nvcheatsheet").toggle()<CR>', desc = 'Toggle Cheatsheet' } },
    config = function()
      require('nvcheatsheet').setup(require 'utils.cheatsheet')
    end,
  }, --  cheatsheet
}
