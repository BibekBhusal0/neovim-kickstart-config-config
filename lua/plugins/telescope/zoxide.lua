local wrap_keys = require "utils.wrap_keys"

return {
  "jvgrootveld/telescope-zoxide",
  keys = wrap_keys {
    {
      "<leader>fz",
      ":lua require('telescope').extensions.zoxide.list()<CR>",
      desc = "Find zoxide folders",
    },
  },
  config = function()
    require("telescope").load_extension "zoxide"
  end,
}
