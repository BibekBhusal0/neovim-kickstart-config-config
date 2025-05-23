local wrap_keys = require "utils.wrap_keys"

return {
  "ziontee113/icon-picker.nvim",
  cmd = {
    "IconPickerInsert",
    "IconPickerNormal",
    "IconPickerYank",
    "PickEmoji",
    "PickEmojiYank",
    "PickEverything",
    "PickEverythingYank",
    "PickIcons",
    "PickIconsYank",
    "PickSymbols",
    "PickSymbolsYank",
  },
  keys = wrap_keys {
    { "<leader>fe", ":PickEmoji<CR>", desc = "Icon Picker Emoji" },
    { "<leader>fE", ":PickEmojiYank emoji<CR>", desc = "Icon Picker Emoji Yank" },
    { "<leader>fi", ":PickIcons<CR>", desc = "Icon Picker" },
    { "<leader>fI", ":PickIconsYank<CR>", desc = "Icon Picker Yank" },
    { "<leader>fS", ":PickSymbols<CR>", desc = "Icon Picker Unicode Symbols" },
  },
  dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
  opts = {},
}
