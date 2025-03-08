local Input = require 'nui.input'
local event = require('nui.utils.autocmd').event

return function(title, callback, val, width, prompt)
  local initalVal = val or ''
  local input = Input({
    position = '50%',
    size = { width = width or #initalVal + 5 },
    border = {
      style = 'single',
      text = {
        top = title,
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    prompt = prompt or '> ',
    default_value = initalVal,

    on_submit = function(value)
      if value ~= '' then
        print(value)
        callback(value)
      else
        print 'Event not executed because input is empty'
      end
    end,
  })

  vim.api.nvim_buf_set_keymap(input.bufnr, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(input.bufnr, 'i', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
  input:mount()

  input:on(event.BufLeave, function()
    input:unmount()
  end)
end
