-- dependencies not lazy loading them
require("plugins.manager").add_plugins {
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  "nvim-tree/nvim-web-devicons",
}

require("plugins.manager").add_plugins {
  require "plugins.ai", -- AI Autocompletion and chat
  require "plugins.debugging", -- Debugger
  require "plugins.fff", -- Fricking fast finder
  require "plugins.git", -- Git stuff like gitsigns, fugitive
  -- require "plugins.lsp", -- All stuff related to LSP
  require "plugins.mini", -- Some utility plugins
  require "plugins.misc", -- Miscellaneous utility plugins
  require "plugins.neotree", -- File explorer for Neovim
  require "plugins.telescope", -- Fuzzy finder for searching
  require "plugins.test", -- Running tests
  require "plugins.treesitter", -- syntax highlighting
  require "plugins.ui", -- Other stuffs like Home page, Status bar
  require "plugins.windowManagemet", -- Buffer, Tab, terminal management
}
