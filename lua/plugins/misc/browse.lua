local wrap_keys = require "utils.wrap_keys"

return {
  "lalitmee/browse.nvim",
  cmd = { "Browse" },
  keys = wrap_keys {
    {
      "<leader>rf",
      ":lua require('browse.devdocs').search_with_filetype()<CR>",
      desc = "Search DevDocs for this",
    },
    { "<leader>rF", ":lua require('browse.devdocs').search()<CR>", desc = "Search DevDocs" },
    {
      "<leader>ro",
      function()
        local file = vim.fn.expand "<cfile>"
        if file:match "https?://" then
          require("browse.utils").default_search(file)
        elseif file:match "^[%w%.%-]+/[%w%.%-_]+$" then
          require("browse.utils").default_search("https://github.com/" .. file)
        else
          local word = vim.fn.expand "<cword>"
          local url = string.format("https://duckduckgo.com/?q=%s", word)
          require("browse.utils").default_search(url)
        end
      end,
      desc = "Open link or search",
    },
    { "<leader>ri", ":Browse input<CR>", desc = "Search" },
  },

  opts = { provider = "duckduckgo" },
}
