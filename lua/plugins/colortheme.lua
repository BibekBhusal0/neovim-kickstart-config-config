return {
  "bluz71/vim-moonfly-colors",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyCursorColor = false
    vim.g.moonflyWinSeparator = 2
    vim.cmd [[colorscheme moonfly]]

    vim.api.nvim_set_hl(0, "WinSeparator", {
      fg = "#999999",
      bg = "NONE",
    })
    require("utils.transparency").apply_transparency()
  end,
}
