local M = {}

M.on_save = function()
  return { cwd = vim.fn.getcwd() }
end

M.on_load = function(data)
  if data and data.cwd then
    vim.cmd("cd " .. vim.fn.fnameescape(data.cwd))
  end
end

return M
