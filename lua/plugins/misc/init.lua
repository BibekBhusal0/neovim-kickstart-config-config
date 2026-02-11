local wrap_keys = require "utils.wrap_keys"

return {
  require "plugins.misc.comments",
  require "plugins.misc.editing",
  require "plugins.misc.exercism",
  require "plugins.misc.games",
  require "plugins.misc.hints",
  require "plugins.misc.leetcode",
  require "plugins.misc.markdown",
  require "plugins.misc.productivity",
  require "plugins.misc.screenshot",
  require "plugins.misc.tmux",
  require "plugins.misc.web-dev",

  {
    "thinca/vim-quickrun",
    keys = wrap_keys {
      { "<leader>rr", ":QuickRun<CR>", desc = "Run" },
      { "<leader>rR", ":w<CR> :QuickRun<CR>", desc = "Save and run" },
    },
    cmd = { "QuickRun" },
    config = function()
      vim.g.quickrun_config = {
        javascript = { command = "bun" },
        javascriptreact = { command = "bun" },
        typescript = { command = "bun" },
        typescriptreact = { command = "bun" },
      }
    end,
  },

  {
    "cxwx/lazyUrlUpdate.nvim",
    opts = {},
    cmd = { "LazyUrlUpdate", "LazyUrlBuild", "LazyUrlOpen" },
    keys = wrap_keys {
      { "<leader>lu", "<cmd>LazyUrlUpdate<CR>", desc = "Update plugin under cursor" },
      { "<leader>lU", "<cmd>LazyUrlBuild<CR>", desc = "Update plugin under cursor" },
    },
  },
}
