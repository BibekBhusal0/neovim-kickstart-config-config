local map = require "utils.map"
map("<leader>gg", ":GitChanges<CR>", "Git open changes")

return {
  require "plugins.git.diffview",
  require "plugins.git.fugitive",
  require "plugins.git.gitsigns",
  require "plugins.git.pipeline",
  require "plugins.git.octo",
  require "plugins.git.worktree",
  require "plugins.git.utils",
}
