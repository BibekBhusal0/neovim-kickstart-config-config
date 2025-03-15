local wrap_keys = require 'utils.wrap_keys'
return {
  {
    'ThePrimeagen/vim-be-good',
    lazy = true,
    cmd = { 'VimBeGood' },
    keys = wrap_keys { { '<leader>zv', ':VimBeGood<CR>', desc = 'Game Vim be good' } },
  },

  {
    'rktjmp/playtime.nvim',
    lazy = true,
    cmd = { 'Playtime' },
    keys = wrap_keys { { '<leader>zp', ':Playtime<CR>', desc = 'Game More' } },
  },

  {
    'seandewar/nvimesweeper',
    lazy = true,
    cmd = { 'Nvimesweeper' },
    keys = wrap_keys { { '<leader>zm', ':Nvimesweeper <CR>', desc = 'Game MineSweeper' } },
  },

  {
    'jim-fx/sudoku.nvim',
    lazy = true,
    cmd = { 'Sudoku' },
    keys = wrap_keys { { '<leader>zs', ':Sudoku<CR>', desc = 'Game Sudoku' } },
    opts = {},
  },

  {
    'seandewar/killersheep.nvim',
    cmd = { 'KillKillKill' },
    keys = wrap_keys { { '<leader>zk', ':KillKillKill<CR>', desc = 'Game Killersheep' } },
  },

  {
    'nvzone/typr',
    keys = wrap_keys {
      { '<leader>zy', ':Typr<CR>', desc = 'Typer start' },
      { '<leader>zY', ':TyprStats<CR>', desc = 'Typer Stats' },
    },
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },

  {
    'eandrju/cellular-automaton.nvim',
    cmd = { 'CellularAutomaton' },
    keys = wrap_keys {
      { '<leader>zr', ':CellularAutomaton make_it_rain<CR>', desc = 'Game CellularAutomaton' },
      { '<leader>zg', ':CellularAutomaton game_of_life<CR>', desc = 'Game CellularAutomaton' },
    },
  },
}
