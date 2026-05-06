local utils = require('lazypack.utils')

local M = {}
local events_bridged = false

local lazy_event_delay = {
  VimEnter = 0,
  Lazy = 10,
  VeryLazy = 100,
}

--- @param p table
--- @param data table
--- @param run_config_once fun()
--- @param augroup integer
function M.register_event_lazy_load(p, data, run_config_once, augroup)
  if not data.event then
    return
  end

  local events = utils.to_list(data.event)

  for _, event in ipairs(events) do
    local autocmd_event = event
    local pattern = nil

    vim.api.nvim_create_autocmd(autocmd_event, {
      group = augroup,
      once = true,
      pattern = pattern,
      desc = ('Lazy load %s on %s'):format(p.spec.name, event),
      callback = function()
        vim.cmd.packadd(p.spec.name)
        run_config_once()
      end,
    })
  end
end

return M
