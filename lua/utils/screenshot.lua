local function freeze_code(options, output_dir)
  local defaults = {
    theme = 'charm',
    margin = 20,
    language = vim.bo.filetype,
  }

  options = options or {}

  for k, v in pairs(defaults) do
    options[k] = options[k] or v
  end

  -- print(vim.inspect(options))

  local full_path = vim.fn.expand '%:p'
  local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
  local output_file = (output_dir or vim.fn.expand '~/Desktop/code') .. '/'
  output_file = output_file .. file_name .. '_' .. os.date '%Y%m%d_%H%M%S' .. '.png'
  local command = 'freeze ' .. full_path .. ' -o ' .. output_file

  local mode = vim.fn.mode()
  if mode == 'v' then
    local start_line = vim.fn.line "'<"
    local end_line = vim.fn.line "'>"
    options.lines = string.format('%d,%d', start_line, end_line)
  end

  for k, v in pairs(options) do
    command = command .. ' --' .. k .. ' ' .. v
  end
  print('Executing command: ' .. command)
  local result = vim.fn.system(command)

  if result then
    print('Screenshot saved to ' .. output_file)
  else
    print 'Failed to take screenshot.'
  end
end

return freeze_code
