return {
  {
    "petertriho/nvim-scrollbar",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      handle = { blend = 0 },
      marks = { Cursor = { color = "#00ff00" } },
      show_in_active_only = true,
      hide_if_all_visible = true,
      handlers = { gitsigns = true },
    },
  }, -- scrollbar showing gitsigns and diagnostics
}
