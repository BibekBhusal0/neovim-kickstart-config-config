require "core.options"
require "core.autocmd"
require "core.startingCommand"
require "core.keymaps"
require "core.commands"
require "core.ui"

vim.pack.add { "https://github.com/folke/lazy.nvim" }

require("lazy").setup {
  require "plugins.ai", -- AI Autocompletion and chat
  require "plugins.debugging", -- Debugger
  require "plugins.fff", -- Fricking fast finder
  require "plugins.git", -- Git stuff like gitsigns, fugitive
  require "plugins.lsp", -- Every thing Lsp related
  require "plugins.mini", -- Yet another file explorer
  require "plugins.misc", -- Miscellaneous utility plugins
  require "plugins.neotree", -- File explorer for Neovim
  require "plugins.sessionManagement", -- management of sessions
  require "plugins.telescope", -- Fuzzy finder for searching
  require "plugins.test", -- Running tests
  require "plugins.treesitter", -- syntax highlighting
  require "plugins.ui", -- Other stuffs like Home page, Status bar
  require "plugins.windowManagemet", -- Buffer, Tab, terminal management
}
