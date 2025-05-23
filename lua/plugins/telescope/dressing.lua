return {
  "stevearc/dressing.nvim",
  lazy = true,
  config = function()
    require("dressing").setup {
      input = {
        enabled = false,
        title_pos = "center",
        start_mode = "insert",
        border = "rounded",
        relative = "win",
      },
      select = {
        enabled = true,
        telescope = require("telescope.themes").get_cursor {
          layout_config = { width = 60, height = 15, preview_cutoff = 200 },
        },
      },
    }
  end,
}
