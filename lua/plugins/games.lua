return {
  {
    'ThePrimeagen/vim-be-good',
    lazy = true,
    cmd = { 'VimBeGood' },
    keys = { { '<leader>zv', '<cmd>VimBeGood<CR>', desc = 'Game Vim be good' } },
  },

  {
    'rktjmp/playtime.nvim',
    lazy = true,
    cmd = { 'Playtime' },
    keys = { { '<leader>zp', '<cmd>Playtime<CR>', desc = 'Game More' } },
  },

  {
    'seandewar/nvimesweeper',
    lazy = true,
    cmd = { 'Nvimesweeper' },
    keys = { { '<leader>zm', '<cmd>Nvimesweeper <CR>', desc = 'Game MineSweeper' } },
  },

  {
    'jim-fx/sudoku.nvim',
    lazy = true,
    cmd = { 'Sudoku' },
    keys = { { '<leader>zs', '<cmd>Sudoku<CR>', desc = 'Game Sudoku' } },
    opts = {},
  },

  {
    'seandewar/killersheep.nvim',
    cmd = { 'KillKillKill' },
    keys = { { '<leader>zk', '<cmd>KillKillKill<CR>', desc = 'Game Killersheep' } },
  },

  {
    'nvzone/typr',
    keys = {
      { '<leader>ty', ':Typr<cr>', desc = 'Typer start' },
      { '<leader>tY', ':TyprStats<cr>', desc = 'Typer Stats' },
    },
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
}
