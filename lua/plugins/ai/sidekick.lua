local wrap_keys = require "utils.wrap_keys"

local fix = "Can you help me fix the diagnostics in {file}?\n{diagnostics}"
return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  opts = {
    cli = {
      prompts = { fix = fix },
      picker = "telescope",
      tools = { antigravity = { cmd = { "agy" } } },
    },
  },
  keys = wrap_keys {
    {
      "<c-.>",
      "<Cmd>Sidekick cli toggle<cr>",
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select { filter = { installed = true } }
      end,
      desc = "Select CLI",
    },
    { "<leader>ad", ":Sidekick cli close<Cr>", desc = "Sidekick Detach a CLI Session" },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send { msg = "{this}" }
      end,
      mode = { "x", "n" },
      desc = "Sidekick Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send { msg = "{file}" }
      end,
      desc = "Sidekick Send File",
    },
    {
      "<leader>aF",
      function()
        require("sidekick.cli").send { msg = fix }
      end,
      desc = "Sidekick Ask to fix",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send { msg = "{selection}" }
      end,
      mode = { "x" },
      desc = "Sidekick Send Visual Selection",
    },
    {
      "<leader>ap",
      ":Sidekick cli prompt<Cr>",
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle { name = "opencode", focus = true }
      end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
