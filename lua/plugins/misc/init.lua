return {
  require 'plugins.misc.editing',
  require 'plugins.misc.hints',
  require 'plugins.misc.looks',
  require 'plugins.misc.productivity',
  require 'plugins.misc.screenshot',
  {
    'thinca/vim-quickrun',
    keys = { { '<leader>rr', ':QuickRun<cr>', desc = 'Run' } },
    cmd = { 'QuickRun' },
  },
}
