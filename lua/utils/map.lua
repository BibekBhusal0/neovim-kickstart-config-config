local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

return map
