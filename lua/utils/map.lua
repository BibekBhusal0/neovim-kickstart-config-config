---Map Set keymap
---@param keys string key combination
---@param func (string|function) function or command to be run after key is pressed
---@param desc string? Descriptation of the keyboard shortcut
---@param mode string|table? Which mode should be the keymap set (defaults to normal)
---@param opts table? Additional options
local function map(keys, func, desc, mode, opts)
  mode = mode or "n"
  local options = { noremap = true, silent = true, desc = desc }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, keys, func, options)
end

return map
