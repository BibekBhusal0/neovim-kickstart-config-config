return {
  "bluz71/vim-nightfly-colors",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nightflyCursorColor = false
    vim.g.nightflyWinSeparator = 2
    vim.cmd [[colorscheme nightfly]]

    require("utils.transparency").apply_transparency()
  end,
}
