require("plugins.manager").add_plugins {
  require "plugins.ai", -- AI Autocompletion and chat
  require "plugins.debugging", -- Debugger
  require "plugins.fff", -- Fricking fast finder
  require "plugins.mini", -- Some utility plugins
  require "plugins.test", -- Running tests
  require "plugins.treesitter", -- syntax highlighting
  require "plugins.telescope", -- Fuzzy finder for searching
  require "plugins.neotree", -- File explorer for Neovim
  require "plugins.ui", -- Other stuffs like Home page, Status bar
  require "plugins.windowManagemet", -- Buffer, Tab, terminal management
}
