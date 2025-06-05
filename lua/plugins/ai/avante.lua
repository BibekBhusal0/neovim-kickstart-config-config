local wrap_keys = require "utils.wrap_keys"

return {
  "yetone/avante.nvim",
  dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteChat",
    "AvanteChatNew",
    "AvanteHistory",
    "AvanteClear",
    "AvanteEdit",
    "AvanteFocus",
    "AvanteRefresh",
    "AvanteStop",
    "AvanteSwitchProvider",
    "AvanteShowRepoMode",
    "AvanteToggle",
    "AvanteModels",
    "AvanteSwitchSelectorProvider",
  },
  keys = wrap_keys {
    { "<leader>A", ":AvanteToggle<CR>", desc = "Avante Toggle" },
    { "<leader>av", ":AvanteChat<CR>", desc = "Avante Chat" },
    { "<leader>aH", ":AvanteHistory<CR>", desc = "Avante History" },
    { "<leader>ae", ":AvanteEdit<CR>", desc = "Avante Edit" },
    { "<leader>af", ":AvanteFocus<CR>", desc = "Avante Focus" },
  },

  version = "*",
  opts = {
    provider = "gemini",
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = false,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = true,
      minimize_diff = true,
      enable_token_counting = true,
    },
    windows = { width = 40 },
    ask = { floating = true },
  },
  build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
}
