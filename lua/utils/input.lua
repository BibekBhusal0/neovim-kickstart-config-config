return function(title, callback, val, width)
  local api = vim.api
  local initialValue = val or ''
  -- local var = vim.fn.expand "<cword>"
  local buf = api.nvim_create_buf(false, true)
  local opts = { height = 1, style = 'minimal', border = 'single', row = 1, col = 1 }

  opts.relative, opts.width = 'cursor', width or #val + 15
  opts.title, opts.title_pos = { { title, '@comment.danger' } }, 'center'

  local win = api.nvim_open_win(buf, true, opts)
  vim.wo[win].winhl = 'Normal:Normal,FloatBorder:Removed'
  api.nvim_set_current_win(win)

  api.nvim_buf_set_lines(buf, 0, -1, true, { ' ' .. initialValue })

  vim.bo[buf].buftype = 'prompt'
  vim.fn.prompt_setprompt(buf, '')
  vim.api.nvim_input 'A'

  vim.keymap.set({ 'i', 'n' }, '<Esc>', '<cmd>q!<CR>', { buffer = buf })

  vim.fn.prompt_setcallback(buf, function(text)
    local newVal = vim.trim(text)
    api.nvim_buf_delete(buf, { force = true })

    if #newVal > 0 and newVal ~= val then
      callback(newVal)
    end
  end)
end
