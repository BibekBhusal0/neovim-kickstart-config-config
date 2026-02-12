local wrap_keys = require "utils.wrap_keys"

local modes = { "v", "n", "t" }
local function hide_lualine()
  vim.o.laststatus = 0
end

return {
  {
    enabled = os.getenv "TMUX" ~= nil,
    "vimpostor/vim-tpipeline",
    config = function()
      hide_lualine()
      vim.opt.fillchars:append { stl = "━", stlnc = "━" }
      vim.g.tpipeline_autoembed = 1
      vim.g.tpipeline_restore = 0
      vim.g.tpipeline_focuslost = 1
      vim.g.tpipeline_clearstl = 1

      vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "WinEnter" }, { callback = hide_lualine })
    end,
  }, -- Merge Status line of neovim and tmux

  {
    "numToStr/Navigator.nvim",
    cmd = {
      "NavigatorLeft",
      "NavigatorDown",
      "NavigatorUp",
      "NavigatorRight",
      "NavigatorPrevious",
      "NavigatorProcessList",
    },
    keys = wrap_keys {
      { "<C-h>", "<C-\\><C-N><CMD>NavigatorLeft<CR>", desc = "Window Left", mode = modes },
      { "<C-j>", "<C-\\><C-N><CMD>NavigatorDown<CR>", desc = "Window Down", mode = modes },
      { "<C-k>", "<C-\\><C-N><CMD>NavigatorUp<CR>", desc = "Window Up", mode = modes },
      { "<C-l>", "<C-\\><C-N><CMD>NavigatorRight<CR>", desc = "Window Right", mode = modes },
      { "<C-\\>", "<C-\\><C-N><CMD>NavigatorPrevious<CR>", desc = "Window Previous", mode = modes },
    },
    config = function()
      require("Navigator").setup()
    end,
  },
}
