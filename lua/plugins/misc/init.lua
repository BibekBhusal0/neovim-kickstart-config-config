local wrap_keys = require 'utils.wrap_keys'

return {
  -- require 'plugins.misc.animation',
  require 'plugins.misc.browser',
  require 'plugins.misc.comments',
  require 'plugins.misc.editing',
  require 'plugins.misc.hints',
  require 'plugins.misc.looks',
  require 'plugins.misc.markdown',
  require 'plugins.misc.productivity',
  require 'plugins.misc.screenshot',
  require 'plugins.misc.web-dev',

  {
    'thinca/vim-quickrun',
    keys = wrap_keys {
      { '<leader>rr', ':QuickRun<CR>', desc = 'Run' },
      { '<leader>rt', ':w<CR> :QuickRun<CR>', desc = 'Save and run' },
    },
    cmd = { 'QuickRun' },
    config = function()
      vim.g.quickrun_config = {}
      vim.g.quickrun_config.js = { command = 'deno run' }
      vim.g.quickrun_config.ts = { command = 'deno run --allow-all' }
    end,
  },
}
