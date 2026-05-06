return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Diffview", "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      icons = require("utils.icons").folder,
      show_help_hints = false,
    },
    keys = {
      { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Diffview file history Current File" },
      { "<leader>gdh", ":DiffviewFileHistory<CR>", desc = "Diffview file history" },
      { "<leader>gdo", ":DiffviewOpen<CR>", desc = "DiffView Open" },
      { "<leader>gdx", ":DiffviewClose<CR>", desc = "Diffview close" },
    },
  },

  {
    "paopaol/telescope-git-diffs.nvim",
    enabled= false,
    keys = {
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
