-- https://codecompanion.olimorris.dev/usage/ui

local M = {}
local notify = require 'notify'
M.loading = false
local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local index = 1
local timer = vim.loop.new_timer()
local max_itr = 1000
local notify_id = {}

function get_current_icon()
  return spinner_frames[(index - 1) % #spinner_frames + 1] -- lua 1 based indexing different from all other languages
end

function M:init()
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestStarted',
    callback = function(request)
      if M.loading == true then
        return
      end
      start_spinner(request)
    end,
  })
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    callback = function(request)
      handle_request_finished(request)
    end,
  })
end

function start_spinner(request)
  M.loading = true
  index = 1
  title = 'AI ' .. request.data.strategy
  timer:start(
    1000,
    150,
    vim.schedule_wrap(function()
      message = get_current_icon() .. '   In progress...'
      redraw_spinner(message, title, '  ')
    end)
  )
end

function redraw_spinner(message, title, icon, timeout)
  local id = notify_id
  if id.id == nil then
    id = nil
  end
  icon = icon or spinner_frames[index % #spinner_frames]
  notify_id = notify(message, 'info', { timeout = timeout or 160, icon = icon, title = title, replace = id })
  index = index + 1
  if index > max_itr then
    stop_spinner()
  end
end

function stop_spinner(message, title, icon)
  timer:stop()
  local id = notify_id
  if id.id == nil then
    id = nil
  end
  notify(message, 'info', { timeout = 4000, icon = icon, title = title, replace = id })
  index = 1
  notify_id = {}
  vim.defer_fn(function()
    M.loading = false
  end, 500)
end

function handle_request_finished(request)
  local message
  local title
  local icon

  if request.data.status == 'success' then
    message = 'Completed'
    title = 'Success'
    icon = ' '
  elseif request.data.status == 'error' then
    message = 'Error'
    title = 'Error'
    icon = ' '
  else
    message = 'Cancelled'
    title = 'Cancelled'
    icon = '󰜺 '
  end

  stop_spinner(message, title, icon)
end

return M
