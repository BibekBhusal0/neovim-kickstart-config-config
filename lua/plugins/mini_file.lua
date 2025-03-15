local wrap_keys = require 'utils.wrap_keys'
return {
  'echasnovski/mini.files',
  keys = wrap_keys { { '<leader>o', ':lua require("mini.files").open()<CR>', desc = 'Open Mini Files' } },
  opts = {},
}
