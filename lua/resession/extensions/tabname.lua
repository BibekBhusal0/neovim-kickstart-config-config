local M = {}

M.on_save = function()
  local tab_names = {}
  local tabs = vim.api.nvim_list_tabpages()

  for _, tab in ipairs(tabs) do
    local tab_nr = vim.api.nvim_tabpage_get_number(tab)
    local ok, name = pcall(vim.api.nvim_tabpage_get_var, tab, "name")
    if ok and name then
      tab_names[tab_nr] = name
    end
  end

  return { tab_names = tab_names }
end

M.on_load = function(data)
  if not data or not data.tab_names then
    return
  end

  local tabs = vim.api.nvim_list_tabpages()

  for _, tab in ipairs(tabs) do
    local tab_nr = vim.api.nvim_tabpage_get_number(tab)
    local name = data.tab_names[tab_nr]
    if name then
      vim.api.nvim_tabpage_set_var(tab, "name", name)
    end
  end

  require("bufferline.ui").refresh()
end

return M
