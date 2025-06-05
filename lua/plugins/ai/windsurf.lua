local wrap_keys = require "utils.wrap_keys"

return {
  "Exafunction/windsurf.nvim",
  cmd = { "Codeium" },
  enabled = false,
  keys = wrap_keys {
    { "<leader>a<leader>", ":Codeium toggle<CR>", desc = "Codeium Start" },
    { "<leader>aC", ":Codeium chat<CR>", desc = "Codeium Chat" },
    {
      "<leader>aT",
      function()
        local server = require("codeium").s
        if server.enabled then
          server:shutdown()
        else
          server:enable()
        end
      end,
      desc = "Codeium Toggle",
    },
  },
  opts = {
    enable_cmp_source = false,
    virtual_text = {
      enabled = true,
      key_bindings = {
        accept = "<A-f>",
        accept_word = "<A-w>",
        accept_line = "<A-a>",
        clear = "<A-c>",
        next = "<A-r>",
        prev = "<A-e>",
      },
      filetypes = {
        codecompanion = false,
        Avante = false,
        AvanteInput = false,
        quickrun = false,
        trouble = false,
        qf = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        noice = false,
        telescope = false,
        TelescopePrompt = false,
      },
    },
  },
}
