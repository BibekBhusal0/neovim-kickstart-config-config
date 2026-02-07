require "core.options"
require "core.keymaps"
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
  require "plugins.alpha", -- Customizable dashboard screen
  require "plugins.autocompletion", -- Autocompletion for code
  require "plugins.bufferline", -- Line showing tabs and buffer
  require "plugins.colortheme", -- Color scheme setup
  require "plugins.debugging", -- Debugger
  require "plugins.games", -- Fun games
  require "plugins.git", -- Git stuff like lazyGit, gitsigns
  require "plugins.leetcode", -- solving leetcode problems
  require "plugins.lsp", -- Language Server Protocol setup
  require "plugins.lualine", -- StatusLine
  require "plugins.mini", -- Yet another file explorer
  require "plugins.misc", -- Miscellaneous utility plugins
  require "plugins.neotree", -- File explorer for Neovim
  require "plugins.none-ls", -- External tools integration (formatters, linters)
  require "plugins.refactoring", -- Code refactoring moving to function file and print
  require "plugins.statuscol", -- Changing status column
  require "plugins.telescope", -- Fuzzy finder for searching
  require "plugins.test", -- Running tests
  require "plugins.tmux", -- Tmux Stuff
  require "plugins.treesitter", -- syntax highlighting
  require "plugins.trouble", -- provides better references diagnostics
  require "plugins.windowManagemet", -- Buffer Tab and Session Management
  require "plugins.sessionManagement", -- management of sessions
}
