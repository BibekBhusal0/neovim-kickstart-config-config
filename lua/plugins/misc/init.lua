local wrap_keys = require 'utils.wrap_keys'

return {
  require 'plugins.misc.editing',
  require 'plugins.misc.hints',
  require 'plugins.misc.looks',
  require 'plugins.misc.productivity',
  require 'plugins.misc.screenshot',
  {
    'thinca/vim-quickrun',
    keys = wrap_keys { { '<leader>rr', ':QuickRun<CR>', desc = 'Run' } },
    cmd = { 'QuickRun' },
  },
}
