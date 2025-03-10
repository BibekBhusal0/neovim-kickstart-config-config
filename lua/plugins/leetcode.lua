local leet_arg = 'leetcode.nvim'
local map = require 'utils.map'

return {
  'kawre/leetcode.nvim',
  cmd = { 'Leet' },
  keys = {
    { '<leader>lC', ':Leet<cr>', desc = 'Leetcode dashboard' },
  },
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  config = function()
    require('leetcode').setup { lang = 'javascript', arg = leet_arg }
    map('<leader>lcc', ':Leet console<cr>', 'Leetcoce console')
    map('<leader>lcd', ':Leet daily<cr>', 'Leetcode proplem of the day')
    map('<leader>lci', ':Leet info<cr>', 'Leetcode problem info')
    map('<leader>lcl', ':Leet lang<cr>', 'Leetcode change language')
    map('<leader>lcL', ':Leet last_submit<cr>', 'Leetcode last submit')
    map('<leader>lco', ':Leet open<cr>', 'Leetcode in browser')
    map('<leader>lcp', ':Leet list<cr>', 'Leetcode problem')
    map('<leader>lcP', ':Leet tabs<cr>', 'Leetcode opened problems')
    map('<leader>lcr', ':Leet random<cr>', 'Leetcode random problem')
    map('<leader>lcR', ':Leet reset<cr>', 'Leetcode reset')
    map('<leader>lcs', ':Leet submit<cr>', 'Leetcode submit')
    map('<leader>lct', ':Leet test<cr>', 'Leetcode test')
  end,
}
