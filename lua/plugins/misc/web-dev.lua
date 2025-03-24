local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'
local webDev = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' }

return {

  {
    'BibekBhusal0/nvim-shadcn',
    opts = {},
    cmd = { 'ShadcnAdd' },
    keys = wrap_keys {
      { '<leader>sa', ':ShadcnAdd<CR>', desc = 'Add shadcn component' },
    },
  },

  {
    'luckasRanarison/tailwind-tools.nvim',
    ft = webDev,
    dependencies = {
      'razak17/tailwind-fold.nvim',
      opts = { ft = webDev },
    },
    config = function()
      require('tailwind-tools').setup {}
      map('<leader>Tf', ':TailwindFoldToggle<CR>', 'Tailwind Fold Toggle')
      map('<leader>TS', ':TailwindSort<CR>', 'Tailwind Sort')
      map('<leader>Ts', ':TailwindSortSelection<CR>', 'Tailwind Sort', 'v')
      map('<leader>Tc', ':TailwindColorToggle<CR>', 'Tailwind Color Toggle')
      map('<leader>st', ':Telescope tailwind classes<CR>', 'Search Tailwind Classes')
      map('<leader>Ts', ':Telescope tailwind classes<CR>', 'Tailwind search')
    end,
  }, -- tailwind color highlights folds and more

  {
    'windwp/nvim-ts-autotag',
    config = true,
    ft = webDev,
  }, -- Autoclose HTML tags
}
