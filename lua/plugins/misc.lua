local map = vim.keymap.set

return {
  {
    'christoomey/vim-tmux-navigator',  -- Tmux & split window navigation
    'tpope/vim-sleuth',                -- Detect tabstop and shiftwidth automatically
    'tpope/vim-rhubarb',               -- GitHub integration for vim-fugitive
    'folke/which-key.nvim',            -- Hints keybinds
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },   -- Autoclose parentheses, brackets, quotes, etc.
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts ={
        signs = false,
        keywards ={
            COPIED_FROM = { icon = " ", color = "hint", alt = { "COPY", "COPIED", "CREDIT" } },
        }
    },
    config = function()
        map('n', '<leader>sc', '<cmd>TodoTelescope<CR>', { desc = 'Search Todo'})
        map('n', '<leader>ll', '<cmd>TodoLocList<CR>', { desc = 'Todo Loc List'})
    --   require('todo-comments')
    end
  },   -- Highlight todo, notes, etc in comments
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },   -- High-performance color highlighter
  {
    'rmagatti/auto-session',
    lazy = false,
    config = function()
      require('auto-session').setup {
        map('n', '<leader>ssf', '<cmd>SessionSearch<CR>', { desc = 'Search Session' }),
        map('n', '<leader>sss', '<cmd>SessionSave<CR>', { desc = 'Save Session' }),
        map('n', '<leader>ssr', '<cmd>SessionRestore<CR>', { desc = 'Restore Session' }),
        map('n', '<leader>ssR', '<cmd>SessionDisableAutoSave<CR>', { desc = 'Toggle Session Autosave' }),
      }
    end

  }  -- session manager
}
