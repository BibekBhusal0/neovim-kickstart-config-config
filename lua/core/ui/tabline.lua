local M = {}
local wrap = require "utils.wrap"

-- Global function for mouse clicks
_G.TablineSwitchBuf = function(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

_G.TablineSwitchTab = function(tabpage)
  vim.api.nvim_set_current_tabpage(tabpage)
end

local function get_buffer_name(bufnr, all_names)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end

  local tail = vim.fn.fnamemodify(name, ":t")
  local count = 0
  for _, other_name in pairs(all_names) do
    if other_name == tail then
      count = count + 1
    end
  end

  if count > 1 then
    return vim.fn.fnamemodify(name, ":p:h:t") .. "/" .. tail
  end
  return tail
end

function M.get_buffers()
  local tab_bufs = vim.t.bufs
  if not tab_bufs then
    return vim.tbl_filter(function(bufnr)
      return vim.fn.buflisted(bufnr) == 1
    end, vim.api.nvim_list_bufs())
  end
  return vim.tbl_filter(function(bufnr)
    return vim.fn.buflisted(bufnr) == 1
  end, tab_bufs)
end

local function render_items(items, switch_func_name)
  local res = ""
  local count = #items
  for i, it in ipairs(items) do
    local side = "none"
    if count == 1 then
      side = "both"
    elseif i == 1 then
      side = "left"
    elseif i == count then
      side = "right"
    end

    local wrapped = wrap(it.component, it.is_active, side)
    if it.id then
      res = res .. string.format("%%%d@v:lua.%s@%s%%X", it.id, switch_func_name, wrapped)
    else
      res = res .. wrapped
    end
  end
  return res
end

function M.tabline()
  local bufnrs = M.get_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_tails = {}
  for _, bufnr in ipairs(bufnrs) do
    table.insert(all_tails, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
  end

  local max_name_width = 25
  local buffer_items = {}
  local current_idx = 1

  for i, bufnr in ipairs(bufnrs) do
    if bufnr == current_buf then
      current_idx = i
    end
    local name = get_buffer_name(bufnr, all_tails)
    local is_active = bufnr == current_buf
    local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    local modified_icon = is_modified and " ●" or ""
    local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
    local icon, _ = require("nvim-web-devicons").get_icon(name, extension, { default = true })

    local display_name = name
    if vim.fn.strdisplaywidth(name) > max_name_width then
      display_name = string.sub(name, 1, max_name_width - 3) .. "..."
    end

    local component = string.format("%s %s%s", icon, display_name, modified_icon)
    table.insert(buffer_items, {
      id = bufnr,
      is_active = is_active,
      component = component,
      width = vim.fn.strdisplaywidth(component) + 2,
    })
  end

  -- Calculate Tabs section first to determine available width
  local tabs = vim.api.nvim_list_tabpages()
  local tab_items = {}
  local tabs_width = 0
  if #tabs > 1 then
    local raw_tabs_content = ""
    for i, tabpage in ipairs(tabs) do
      local is_active = tabpage == vim.api.nvim_get_current_tabpage()
      local name = i
      local ok, tab_name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "name")
      if ok and tab_name and tab_name ~= "" then
        name = tab_name
      end
      table.insert(tab_items, {
        id = tabpage,
        is_active = is_active,
        component = tostring(name),
      })
      raw_tabs_content = raw_tabs_content .. " " .. name .. " "
    end
    tabs_width = vim.fn.strdisplaywidth(raw_tabs_content) + 4
  end

  local available_width = vim.o.columns - tabs_width - 10
  local start_idx, end_idx = 1, #buffer_items
  local total_needed = 0
  for _, it in ipairs(buffer_items) do
    total_needed = total_needed + it.width
  end

  if total_needed > available_width then
    start_idx, end_idx = current_idx, current_idx
    local current_width = buffer_items[current_idx].width
    local l, r = current_idx - 1, current_idx + 1
    local l_done, r_done = false, false

    while not (l_done and r_done) do
      if not r_done and r <= #buffer_items then
        if current_width + buffer_items[r].width + 6 <= available_width then
          current_width = current_width + buffer_items[r].width
          end_idx = r
          r = r + 1
        else
          r_done = true
        end
      else
        r_done = true
      end

      if not l_done and l >= 1 then
        if current_width + buffer_items[l].width + 6 <= available_width then
          current_width = current_width + buffer_items[l].width
          start_idx = l
          l = l - 1
        else
          l_done = true
        end
      else
        l_done = true
      end
    end
  end

  local visible_items = {}
  if start_idx > 1 then
    table.insert(visible_items, { component = "...", is_active = false })
  end
  for i = start_idx, end_idx do
    table.insert(visible_items, buffer_items[i])
  end
  if end_idx < #buffer_items then
    table.insert(visible_items, { component = "...", is_active = false })
  end

  local res_buffers = render_items(visible_items, "TablineSwitchBuf")
  local res_tabs = render_items(tab_items, "TablineSwitchTab")

  return " " .. res_buffers .. "%=" .. res_tabs .. " "
end

function M.setup()
  vim.opt.tabline = "%!v:lua.require'core.ui.tabline'.tabline()"
end

return M
