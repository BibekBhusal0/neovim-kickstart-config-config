require 'core.options'
require 'core.keymaps'
require 'core.snippets'

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  require 'plugins.treesitter', -- syntax highlighting
  require 'plugins.colortheme', -- Color scheme setup
  require 'plugins.telescope', -- Fuzzy finder for searching
  require 'plugins.neotree', -- File explorer for Neovim
  require 'plugins.mini_file', -- Yet another file explorer
  require 'plugins.windowManagemet', -- Buffer Tab and Session Management
  require 'plugins.lualine', -- Statusline
  require 'plugins.lsp', -- Language Server Protocol setup
  require 'plugins.autocompletion', -- Autocompletion for code
  require 'plugins.none-ls', -- External tools integration (formatters, linters)
  require 'plugins.git', -- Git stuff like lazygit, gitsigns
  require 'plugins.alpha', -- Customizable dashboard screen
  require 'plugins.ai', -- syntax highlighting
  require 'plugins.misc', -- Miscellaneous utility plugins
  require 'plugins.games', -- Fun games
  require 'plugins.leetcode', -- solving leetcode problems
}
