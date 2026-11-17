return {
  {
    "petertriho/nvim-scrollbar",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      providers = { gitsigns = true },
      marks = { Cursor = { highlight = { fg = "#00ff00" } } },
      scrollbar = {
        visibility = "active",
        hide_if_all_visible = true,
        thumb = { blend = 0 },
      },
    },
  }, -- scrollbar showing gitsigns and diagnostics

  {
    "rachartier/tiny-cmdline.nvim",
    init = function()
      vim.opt.cmdheight = 0
    end,
    opts = { native_types = { "-" } },
    event = "CmdlineEnter",
  },
}
