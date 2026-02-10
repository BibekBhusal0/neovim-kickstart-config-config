---Map Set keymap
---@param keys string key combination
---@param func (string|function) function or command to be run after key is pressed
---@param desc string? Descriptation of the keyboard shortcut
---@param mode string|table? Which mode should be the keymap set (defaults to normal)
local function map(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

return map
