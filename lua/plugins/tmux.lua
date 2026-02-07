local wrap_keys = require "utils.wrap_keys"

return {
  {
    enabled = os.getenv "TMUX" ~= nil,
    "vimpostor/vim-tpipeline",
    config = function()
      vim.g.tpipeline_autoembed = 1
      vim.g.tpipeline_restore = 0
      vim.g.tpipeline_clearstl = 1
      vim.g.tpipeline_focuslost = 0
    end,
  }, -- Merge Status line of neovim and tmux

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = wrap_keys {
      { "<C-h>", ":TmuxNavigateLeft<CR>", desc = "Window Left" },
      { "<C-j>", ":TmuxNavigateDown<CR>", desc = "Window Down" },
      { "<C-k>", ":TmuxNavigateUp<CR>", desc = "Window Up" },
      { "<C-l>", ":TmuxNavigateRight<CR>", desc = "Window Right" },
      { "<C-\\>", ":TmuxNavigatePrevious<CR>", desc = "Window Previous" },
    },
  },
}
