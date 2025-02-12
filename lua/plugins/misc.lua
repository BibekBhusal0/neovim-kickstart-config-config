return {
  {
    'christoomey/vim-tmux-navigator',  -- Tmux & split window navigation
    'tpope/vim-sleuth',                -- Detect tabstop and shiftwidth automatically
    'tpope/vim-fugitive',              -- Powerful Git integration for Vim
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
    opts = { signs = false },
  },   -- Highlight todo, notes, etc in comments
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },   -- High-performance color highlighter

}
