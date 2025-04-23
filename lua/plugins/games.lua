local wrap_keys = require "utils.wrap_keys"
return {
  {
    "ThePrimeagen/vim-be-good",
    lazy = true,
    cmd = { "VimBeGood" },
    keys = wrap_keys { { "<leader>zv", ":VimBeGood<CR>", desc = "Game Vim be good" } },
  },

  {
    "rktjmp/playtime.nvim",
    lazy = true,
    cmd = { "Playtime" },
    keys = wrap_keys { { "<leader>zp", ":Playtime<CR>", desc = "Game More" } },
  },

  {
    "seandewar/nvimesweeper",
    dependencies = { "stevearc/dressing.nvim" },
    lazy = true,
    cmd = { "Nvimesweeper" },
    keys = wrap_keys { { "<leader>zm", ":Nvimesweeper <CR>", desc = "Game MineSweeper" } },
  },

  {
    "jim-fx/sudoku.nvim",
    lazy = true,
    cmd = { "Sudoku" },
    keys = wrap_keys { { "<leader>zS", ":Sudoku<CR>", desc = "Game Sudoku" } },
    opts = {},
  },

  {
    "seandewar/killersheep.nvim",
    cmd = { "KillKillKill" },
    keys = wrap_keys { { "<leader>zk", ":KillKillKill<CR>", desc = "Game Killersheep" } },
  },

  {
    "nvzone/typr",
    keys = wrap_keys {
      { "<leader>zy", ":Typr<CR>", desc = "Typer start" },
      { "<leader>zY", ":TyprStats<CR>", desc = "Typer Stats" },
    },
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },

  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    keys = wrap_keys {
      { "<leader>zr", ":CellularAutomaton make_it_rain<CR>", desc = "Game Make it rain" },
      { "<leader>zG", ":CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },

  {
    "alanfortlink/blackjack.nvim",
    cmd = { "BlackJackNewGame", "BlackJackQuit", "BlackJackResetScores" },
    keys = wrap_keys {
      { "<leader>zb", ":BlackJackNewGame<CR>", desc = "Game Black Jack" },
    },
  },

  {
    "alec-gibson/nvim-tetris",
    cmd = { "Tetris" },
    keys = wrap_keys {
      { "<leader>zt", ":Tetris<CR>", desc = "Game Tetris" },
    },
  },

  {
    "marco-souza/snake.nvim",
    opts = {},
    cmd = "Snake",
    keys = wrap_keys { { "<leader>zs", ":Sudoku<CR>", desc = "Game Sudoku" } },
  },

  {
    "vuciv/golf",
    cmd = { "Golf", "GolfToday" },
    keys = wrap_keys {
      { "<leader>zgt", ":GolfToday<CR>", desc = "Game Golf Today" },
      { "<leader>zge", ":Golf easy<CR>", desc = "Game Golf Easy" },
      { "<leader>zgm", ":Golf medium<CR>", desc = "Game Golf Medium" },
      { "<leader>zgh", ":Golf hard<CR>", desc = "Game Golf Hard" },
    },
  },
}
