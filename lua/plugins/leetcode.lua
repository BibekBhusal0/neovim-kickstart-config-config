local wrap_keys = require 'utils.wrap_keys'
local leet_arg = 'leetcode.nvim'
local map = require 'utils.map'

return {
  'kawre/leetcode.nvim',
  cmd = { 'Leet' },
  keys = wrap_keys {
    { '<leader>lC', ':Leet<CR>', desc = 'Leetcode dashboard' },
  },
  lazy = leet_arg ~= vim.fn.argv(0, -1),

  config = function()
    require('leetcode').setup { lang = 'typescript', arg = leet_arg }
    map('<leader>lcc', ':Leet console<CR>', 'Leetcoce console')
    map('<leader>lcd', ':Leet daily<CR>', 'Leetcode proplem of the day')
    map('<leader>lci', ':Leet info<CR>', 'Leetcode problem info')
    map('<leader>lcl', ':Leet lang<CR>', 'Leetcode change language')
    map('<leader>lcL', ':Leet last_submit<CR>', 'Leetcode last submit')
    map('<leader>lco', ':Leet open<CR>', 'Leetcode in browser')
    map('<leader>lcp', ':Leet list<CR>', 'Leetcode problem')
    map('<leader>lcP', ':Leet tabs<CR>', 'Leetcode opened problems')
    map('<leader>lcr', ':Leet random<CR>', 'Leetcode random problem')
    map('<leader>lcR', ':Leet reset<CR>', 'Leetcode reset')
    map('<leader>lcs', ':Leet submit<CR>', 'Leetcode submit')
    map('<leader>lct', ':Leet test<CR>', 'Leetcode test')
  end,
}
