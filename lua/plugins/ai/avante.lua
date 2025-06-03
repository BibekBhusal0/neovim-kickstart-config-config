local wrap_keys = require "utils.wrap_keys"

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
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
      auto_set_keymaps = false,
    },
  },
  build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
  -- dependencies = { "zbirenbaum/copilot.lua" },
}
