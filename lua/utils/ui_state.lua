local M = {}
local ui_state = {
  laststatus = nil,
  showtabline = nil,
}

local function hide_ui()
  if ui_state.laststatus == nil then
    ui_state.laststatus = vim.o.laststatus
  end
  if ui_state.showtabline == nil then
    ui_state.showtabline = vim.o.showtabline
  end

  vim.o.laststatus = 0
  vim.o.showtabline = 0
end

local function restore_ui()
  if ui_state.laststatus ~= nil then
    vim.o.laststatus = ui_state.laststatus
    ui_state.laststatus = nil
  end
  if ui_state.showtabline ~= nil then
    vim.o.showtabline = ui_state.showtabline
    ui_state.showtabline = nil
  end
end

M.hide_ui = hide_ui
M.restore_ui = restore_ui
return M
