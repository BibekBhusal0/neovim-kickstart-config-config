local wrap_keys = require "utils.wrap_keys"

return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = wrap_keys { { "<leader>lg", ":LazyGit<CR>", desc = "Toggle LazyGit" } },
}
