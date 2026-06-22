local map = require "utils.map"

map("<leader>g/", ":Git stash<CR>", "Git stash")
map("<leader>g[", ":Git push --force<CR>", "Git push Force")
map("<leader>gA", ":Git add %<CR>", "Git add current file")
map("<leader>ga", ":Git add .<CR>", "Git add all files")
map("<leader>gi", ":Git init<CR>", "Git Init")
map("<leader>gJ", ":Git commit --amend --no-edit<CR>", "Git commit to last commit")
map("<leader>gj", ":Git commit -a --amend --no-edit<CR>", "Git add and commit to last commit")
map("<leader>gP", ":Git pull<CR>", "Git pull")
map("<leader>gp", ":Git push<CR>", "Git push")

return {
  {
    "nvim-mini/mini-git",
    config = function()
      require("mini.git").setup()
    end,
    cmd = { "Git" },
  },

  require "plugins.git.diffview",
  require "plugins.git.gitsigns",
  require "plugins.git.pipeline",
  require "plugins.git.octo",
  require "plugins.git.worktree",
  require "plugins.git.utils",
}
