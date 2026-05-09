return {
  "bluz71/vim-moonfly-colors",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyCursorColor = false
    vim.g.moonflyWinSeparator = 2
    vim.cmd [[colorscheme moonfly]]

    require("utils.transparency").apply_transparency()
  end,
}
