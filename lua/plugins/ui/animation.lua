local map = require "utils.map"

return {
  {
    "sphamba/smear-cursor.nvim",
    event = { "CursorHold", "CursorHoldI" },
    opts = {},
    config = function()
      local sm = require "smear_cursor"
      sm.setup { cursor_color = "#ff8800" }
      sm.enabled = true
      map("<leader>tc", ":SmearCursorToggle<CR>", "Toggle Smear Cursor")
    end,
  }, -- cursor animation

  {
    "karb94/neoscroll.nvim",
    keys = {
      { "<C-u>", mode = { "n", "v", "x" } },
      { "<C-d>", mode = { "n", "v", "x" } },
      { "<C-b>", mode = { "n", "v", "x" } },
      { "<C-f>", mode = { "n", "v", "x" } },
      { "<C-y>", mode = { "n", "v", "x" } },
      { "<C-e>", mode = { "n", "v", "x" } },
      { "zt", mode = { "n", "v", "x" } },
      { "zz", mode = { "n", "v", "x" } },
      { "zb", mode = { "n", "v", "x" } },
    },
    opts = { hide_cursor = true },
  }, -- Smooth scrolling
}
