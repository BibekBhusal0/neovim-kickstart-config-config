local wrap_keys = require "utils.wrap_keys"

return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  opts = {},
  keys = wrap_keys {
    {
      "<leader><tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = " Sidekick Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      ":Sidekick cli close <Cr>",
      desc = "Sidekick Detach a CLI Session",
    },
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
