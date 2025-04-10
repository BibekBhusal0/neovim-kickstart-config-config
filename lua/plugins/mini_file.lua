local wrap_keys = require 'utils.wrap_keys'

local au_group = vim.api.nvim_create_augroup('__mini', { clear = true })
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  group = au_group,
  desc = 'LSP Rename file',
  callback = function(event)
    local ok, rename = pcall(require, 'lsp-file-operations.did-rename')
    if not ok then
      return
    end
    vim.defer_fn(function()
      require('mini.files').close()
    end, 1)
    vim.defer_fn(function()
      rename.callback { old_name = event.data.from, new_name = event.data.to }
    end, 1)
  end,
})

return {
  'echasnovski/mini.files',
  keys = wrap_keys {
    { '<leader>o', ':lua require("mini.files").open()<CR>', desc = 'Open Mini Files' },
  },
  config = function()
    require('mini.files').setup {
      options = { permanent_delete = false },
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 30,
        width_nofocus = 13,
        width_preview = 40,
      },
    }
  end,
}
