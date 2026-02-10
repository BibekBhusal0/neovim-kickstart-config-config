local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

map("<leader>cj", ":cprevious<CR>", "QuickFix Next")
map("<leader>ck", ":cnext<CR>", "QuickFix Previous")
map("<leader>c[", ":cfirst<CR>", "QuickFix First")
map("<leader>c]", ":clast<CR>", "QuickFix Last")

return {
  "folke/trouble.nvim",
  config = function()
    local trouble = require "trouble"
    trouble.setup {
      icons = { kinds = require("utils.icons").get_padded_icon "symbols" },
      keys = { l = "jump", J = "next", K = "prev", f = "fold_toggle" },
    }
    map("<leader>cl", function()
      trouble.next { skip_groups = true, jump = true }
    end, "Trouble next")
    map("<leader>ch", function()
      trouble.prev { jump = true }
    end, "Trouble prev")
  end,
  cmd = "Trouble",
  keys = wrap_keys {
    {
      "<leader>cE",
      ":Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Trouble Diagnostics Toggle Buffer",
    },
    { "<leader>ce", ":Trouble diagnostics toggle<CR>", desc = "Trouble Diagnostics Toggle" },
    {
      "<leader>cL",
      ":Trouble lsp toggle focus=false win.position=right<CR>",
      desc = "Trouble LSP Toggle",
    },
    { "<leader>cq", ":Trouble qflist toggle<CR>", desc = "Trouble Quickfix Toggle" },
    { "<leader>cs", ":Trouble symbols toggle focus=false<CR>", desc = "Trouble Symbols Toggle" },
    { "<leader>ct", ":Trouble toggle<CR>", desc = "Trouble  Toggle" },
  },
}
