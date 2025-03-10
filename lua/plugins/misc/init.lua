return {
  require 'plugins.misc.editing',
  require 'plugins.misc.hints',
  require 'plugins.misc.looks',
  require 'plugins.misc.productivity',
  require 'plugins.misc.screenshot',
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
}
