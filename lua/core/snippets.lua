-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_lines = { current_line = true },
  underline = false,
  update_in_insert = true,
  float = { source = 'always' },
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

if vim.fn.argc() > 0 then
  if vim.fn.argv(0) == 'config' then
    vim.cmd('lcd ' .. vim.fn.stdpath 'config')
    vim.cmd('silent bwipeout ' .. vim.fn.argv(0))
    vim.defer_fn(function()
      vim.cmd('edit ' .. vim.fn.stdpath 'config' .. '/init.lua')
      vim.cmd 'normal! zR'
    end, 1)
  end
end
