local ui_colors = require "core.ui.colors"

ui_colors.setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    ui_colors.setup_highlights()
  end,
})

require("core.ui.statuscolumn").setup()
require("core.ui.statusline").setup()
require("core.ui.tabline").setup()
require "core.ui.ui2"
