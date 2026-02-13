local wrap_keys = require "utils.wrap_keys"

return {
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Diffview", "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      hooks = {
        view_post_layout = function()
          if package.loaded["windows"] then
            vim.cmd "WindowsDisableAutowidth"
          end
        end,
      },
      icons = require("utils.icons").folder,
      show_help_hints = false,
    },
    keys = wrap_keys {
      { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Diffview file history Current File" },
      { "<leader>gdh", ":DiffviewFileHistory<CR>", desc = "Diffview file history" },
      { "<leader>gdo", ":DiffviewOpen<CR>", desc = "DiffView Open" },
      { "<leader>gdx", ":DiffviewClose<CR>", desc = "Diffview close" },
    },
  },

  {
    "paopaol/telescope-git-diffs.nvim",
    keys = wrap_keys {
      {
        "<leader>gdc",
        ":Telescope git_diffs  diff_commits previewer=false<CR>",
        desc = "Diffview Compare commmits",
      },
    },
    config = function()
      require("telescope").setup {
        extensions = { git_diffs = { enable_preview_diff = false } },
      }
    end,
  },
}
