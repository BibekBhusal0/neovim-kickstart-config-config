local wrap_keys = require "utils.wrap_keys"

return {
  {
    "seandewar/nvimesweeper",
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    lazy = true,
    cmd = { "Nvimesweeper" },
    keys = wrap_keys { { "<leader>zm", ":Nvimesweeper <CR>", desc = "Game MineSweeper" } },
  },

  {
    "seandewar/killersheep.nvim",
    cmd = { "KillKillKill" },
    keys = wrap_keys { { "<leader>zk", ":KillKillKill<CR>", desc = "Game Killersheep" } },
  },

  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    config = function()
      vim.opt.spell = false
    end,
    keys = wrap_keys {
      { "<leader>zr", ":CellularAutomaton make_it_rain<CR>", desc = "Game Make it rain" },
      { "<leader>zG", ":CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },

  {
    "alec-gibson/nvim-tetris",
    cmd = { "Tetris" },
    enabled = true,
    keys = wrap_keys {
      { "<leader>zt", ":Tetris<CR>", desc = "Game Tetris" },
    },
  },

  {
    "letieu/hacker.nvim",
    config = function()
      vim.opt.spell = false
    end,
    cmd = { "Hack", "HackAuto", "HackFollow", "HackFollowAuto" },
  },
}
