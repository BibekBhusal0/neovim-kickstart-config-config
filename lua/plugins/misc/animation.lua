local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

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

  {
    "rachartier/tiny-glimmer.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enabled = true,
      overwrite = {
        yank = { enabled = true },
        search = { enabled = false },
        paste = { enabled = true },
        undo = { enabled = true },
        redo = { enabled = true },
      },
      animations = {
        fade = { from_color = "#c4841d" },
        reverse_fade = { from_color = "#312107" },
      },
      virt_text = {
        priority = 2048,
      },
    },
    keys = wrap_keys {
      { "<leader>tG", ":lua require('tiny-glimmer').toggle()<CR>", desc = "Toggle Glimmer" },
    },
  }, -- highlight not while yanking pasting
}
