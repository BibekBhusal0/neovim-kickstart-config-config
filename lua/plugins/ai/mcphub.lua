local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

map("<leader>mc", ":e C:/users/bibek/.config/mcphub/servers.json<CR>", "MCP config")

return {
  "ravitemer/mcphub.nvim",
  keys = wrap_keys { { "<leader>M", ":MCPHub<CR>", desc = "MCP hub Open" } },
  cmd = "MCPHub",
  build = "npm install -g mcp-hub@latest",
  opts = { auto_approve = true },
}
