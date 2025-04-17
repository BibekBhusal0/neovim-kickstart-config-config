local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'

map('<leader>M', ':e C:/users/bibek/.config/mcphub/servers.json<CR>', 'MCP config')

return {
  'ravitemer/mcphub.nvim',
  keys = wrap_keys {
    { '<leader>m', ':MCPHub<CR>', desc = 'MCP hub Open' },
  },
  cmd = 'MCPHub',
  build = 'npm install -g mcp-hub@latest',
  config = function()
    local llx = require('lualine.config').get_config().sections.lualine_x
    table.insert(llx, 1, require 'mcphub.extensions.lualine')
    require('lualine').setup { sections = { lualine_x = llx } }
    require('mcphub').setup {
      codecompanion = {
        show_result_in_chat = true,
        make_vars = true,
        make_slash_commands = true,
      },
    }
  end,
}
