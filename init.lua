require "core.options"
require "core.autocmd"
require "core.startingCommand"
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

require "plugins"

require("lazy").setup {
  require "plugins.lsp", -- Every thing Lsp related
  require "plugins.sessionManagement", -- management of sessions
}
