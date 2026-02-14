local wrap_keys = require "utils.wrap_keys"

return {
  "BibekBhusal0/nvim-git-utils",
  dir = "~/Code/nvim-plugins/nvim-git-utils",
  opts = { commit_input = { hints = false } },
  cmd = {
    "GitAddCommit",
    "GitCommit",
    "GitChangeLastCommit",
    "GitChanges",
    "DiffviewCompareBranchesTelescope",
    "DiffviewFileHistoryTelescope",
  },
  keys = wrap_keys {
    { "<leader>gc", ":GitAddCommit<CR>", desc = "Git add and commit" },
    { "<leader>gC", ":GitCommit<CR>", desc = "Git commit" },
    { "<leader>ge", ":GitChangeLastCommit<CR>", desc = "Git Change last commit message" },
    { "<leader>gg", ":GitChanges<CR>", desc = "Git open changed files" },
    { "<leader>gdb", ":DiffviewCompareBranchesTelescope<CR>", desc = "Diffview Compare Branches" },
    {
      "<leader>gdF",
      ":DiffviewFileHistoryTelescope<CR>",
      desc = "Diffview File history Telescope",
    },
  },
}
