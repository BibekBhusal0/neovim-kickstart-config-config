local wrap_keys = require 'utils.wrap_keys'

return {
  {
    {
      'numToStr/Comment.nvim',
      dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      keys = {
        { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
        { 'gc', mode = { 'n', 'o', 'x' }, desc = 'Comment toggle' },
        { 'gbc', mode = 'n', desc = 'Comment toggle current block' },
        { 'gb', mode = { 'n', 'o', 'x' }, desc = 'Comment toggle blockwise' },
      },
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    }, -- Easily comment visual regions/lines

    {
      'LudoPinelli/comment-box.nvim',
      keys = wrap_keys {
        { '<leader>CB', ':CBlcbox<CR>', desc = 'Comment box' },
        { '<leader>CL', ':CBlcline<CR>', desc = 'Comment Line' },
      },
      cmd = {
        'CBllbox',
        'CBllbox',
        'CBlcbox',
        'CBlrbox',
        'CBccbox',
        'CBcrbox',
        'CBcrbox',
        'CBrlbox',
        'CBrcbox',
        'CBrrbox',
        'CBalbox',
        'CBacbox',
        'CBarbox',
        'CBraline',
        'CBlcline',
        'CBlrline',
        'CBccline',
        'CBcrline',
        'CBcrline',
        'CBrlline',
        'CBrcline',
        'CBrrline',
        'CBcatalog',
      },
      opts = {},
      -- ╭─────────────────────────────────────────────────────────╮
      -- │                Makes comments like this                 │
      -- ╰─────────────────────────────────────────────────────────╯
    },

    {
      'folke/todo-comments.nvim',
      event = { 'BufNewFile', 'BufReadPost' },
      keys = wrap_keys {
        { '<leader>sc', ':TodoTelescope<CR>', desc = 'Todo Search Telescope' },
        { '<leader>cT', ':Trouble todo<CR>', desc = 'Todo Loc List' },
      },
      config = function()
        require('todo-comments').setup { signs = false }
      end,
    }, -- WARNING: Highlights todo, notes, etc in comments
  },
}
