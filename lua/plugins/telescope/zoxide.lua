local wrap_keys = require "utils.wrap_keys"

vim.api.nvim_create_user_command("Zoxide", function()
  require("telescope").extensions.zoxide.list { theme = "dropdown", previewer = false }
end, {})

return {
  "jvgrootveld/telescope-zoxide",
  keys = wrap_keys {
    { "<leader>fz", ":Zoxide<CR>", desc = "Find zoxide directories" },
    { "<leader>cd", ":Zoxide<CR>", desc = "Change Directory" },
  },
  config = function()
    require("telescope").setup { extensions = { zoxide = { prompt_title = "Directories" } } }
  end,
}
