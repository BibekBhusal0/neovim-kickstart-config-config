local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'
local webDev = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' }

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
    opts = {},
    ft = webDev,
  }, -- Autoclose HTML tags

  {
    'TiagoMDG/react-comp-gen.nvim',
    cmd = { 'CreateComponent' },
    keys = wrap_keys {
      {
        '<leader>CC',
        function()
          require 'utils.input'('Name', function(text)
            vim.cmd('CreateComponent ' .. text)
          end, '', 20, '󰜈 ')
        end,
        desc = 'Add component',
      },
    },
    opts = {
      defult_path = '/src/components/',
      generate_css_file = false,
    },
  },

  {
    'farias-hecdin/CSSVarViewer',
    ft = { 'css' },
    opts = {},
  },

  {
    'mawkler/jsx-element.nvim',
    ft = { 'typescriptreact', 'javascriptreact', 'javascript' },
    opts = { enabled = false }, -- enabled in treesitter textobjects
  },
}
