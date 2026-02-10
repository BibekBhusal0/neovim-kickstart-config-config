require "core.options"
require "core.keymaps"
require "core.commands"
require "core.snippets"

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  require "plugins.ai", -- AI Autocompletion and chat
  require "plugins.debugging", -- Debugger
  require "plugins.git", -- Git stuff like gitsigns, fugitive
  require "plugins.lsp", -- Every thing Lsp related
  require "plugins.mini", -- Yet another file explorer
  require "plugins.misc", -- Miscellaneous utility plugins
  require "plugins.neotree", -- File explorer for Neovim
  require "plugins.refactoring", -- Code refactoring moving to function file and print
  require "plugins.sessionManagement", -- management of sessions
  require "plugins.telescope", -- Fuzzy finder for searching
  require "plugins.test", -- Running tests
  require "plugins.treesitter", -- syntax highlighting
  require "plugins.ui", -- Other stuffs like Home page, Status bar
  require "plugins.windowManagemet", -- Buffer, Tab, terminal management
}
