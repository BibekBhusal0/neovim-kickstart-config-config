local leet_arg = 'leetcode.nvim'

return {
  'kawre/leetcode.nvim',
  cmd = { 'Leet' },
  keys = {
    { '<leader>lC', ':Leet<cr>', desc = 'Leetcode dashboard' },
  },
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  opts = { arg = leet_arg },
}
