local M = {}

local icons = require "utils.icons"

local SL = icons.ui

-- Global function for mouse clicks
_G.TablineSwitchBuf = function(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

_G.TablineSwitchTab = function(tabpage)
  vim.api.nvim_set_current_tabpage(tabpage)
end

local function get_buffer_name(bufnr, all_names)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then return "[No Name]" end

  local tail = vim.fn.fnamemodify(name, ":t")
  local count = 0
  for _, other_name in pairs(all_names) do
    if other_name == tail then count = count + 1 end
  end

  if count > 1 then
    return vim.fn.fnamemodify(name, ":p:h:t") .. "/" .. tail
  end
  return tail
end

local function get_buffers()
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

function M.tabline()
  local bufnrs = get_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_tails = {}
  for _, bufnr in ipairs(bufnrs) do
    table.insert(all_tails, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
  end

  local max_name_width = 25
  local buffer_parts = {}
  local first_buf_hl = ""
  local last_buf_hl = ""
  local current_idx = 1

  for i, bufnr in ipairs(bufnrs) do
    if bufnr == current_buf then current_idx = i end
    
    local name = get_buffer_name(bufnr, all_tails)
    local is_active = bufnr == current_buf
    local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    local modified_icon = is_modified and " ●" or ""
    
    local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
    local icon, _ = require("nvim-web-devicons").get_icon(name, extension, { default = true })
    
    local hl_name = is_active and "UIActive" or "UIInactive"
    if i == 1 then first_buf_hl = hl_name end
    if i == #bufnrs then last_buf_hl = hl_name end

    local display_name = name
    if vim.fn.strdisplaywidth(name) > max_name_width then
      display_name = string.sub(name, 1, max_name_width - 3) .. "..."
    end
    
    local content = string.format("%%#%s# %s %s%s ", hl_name, icon, display_name, modified_icon)
    table.insert(buffer_parts, string.format("%%%d@v:lua.TablineSwitchBuf@%s%%X", bufnr, content))
  end

  -- Buffer Overflow Handling
  local available_width = vim.o.columns - 40
  local current_total_width = 0
  local visible_parts = {}
  
  -- Estimate width and truncate
  -- For simplicity, if too many buffers, show current and some around it
  if #buffer_parts > 0 then
    local start_idx = 1
    local end_idx = #buffer_parts
    
    -- Very crude estimation: average width 20
    local max_visible = math.floor(available_width / 20)
    if #buffer_parts > max_visible then
      start_idx = math.max(1, current_idx - math.floor(max_visible / 2))
      end_idx = math.min(#buffer_parts, start_idx + max_visible - 1)
      if end_idx == #buffer_parts then start_idx = math.max(1, end_idx - max_visible + 1) end
    end

    if start_idx > 1 then table.insert(visible_parts, "%#UIInactive#... ") end
    for i = start_idx, end_idx do
      table.insert(visible_parts, buffer_parts[i])
    end
    if end_idx < #buffer_parts then table.insert(visible_parts, "%#UIInactive# ...") end
    
    -- Recalculate end highlights for separators
    first_buf_hl = (start_idx > 1) and "UIInactive" or (bufnrs[start_idx] == current_buf and "UIActive" or "UIInactive")
    last_buf_hl = (end_idx < #buffer_parts) and "UIInactive" or (bufnrs[end_idx] == current_buf and "UIActive" or "UIInactive")
  end

  local res_buffers = ""
  if #visible_parts > 0 then
    res_buffers = string.format("%%#%sSep#%s%s%%#%sSep#%s", first_buf_hl, SL.sep_l, table.concat(visible_parts, ""), last_buf_hl, SL.sep_r)
  end

  -- Tabs section
  local tabs = vim.api.nvim_list_tabpages()
  local tab_res = ""
  if #tabs > 1 then
    local tab_parts = {}
    local first_tab_hl = ""
    local last_tab_hl = ""

    for i, tabpage in ipairs(tabs) do
      local is_active = tabpage == vim.api.nvim_get_current_tabpage()
      local name = i
      local ok, tab_name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "name")
      if ok and tab_name and tab_name ~= "" then name = tab_name end
      
      local hl_name = is_active and "UIActive" or "UIInactive"
      if i == 1 then first_tab_hl = hl_name end
      if i == #tabs then last_tab_hl = hl_name end
      
      table.insert(tab_parts, string.format("%%%d@v:lua.TablineSwitchTab@%%#%s# %s %%X", tabpage, hl_name, name))
    end
    tab_res = string.format("%%#%sSep#%s%s%%#%sSep#%s", first_tab_hl, SL.sep_l, table.concat(tab_parts, ""), last_tab_hl, SL.sep_r)
  end

  return "  " .. res_buffers .. "%=" .. tab_res .. " "
end

function M.setup()
  vim.opt.tabline = "%!v:lua.require'core.ui.tabline'.tabline()"
  
  local map = require "utils.map"
  map("<leader>tr", function()
    require "utils.input"("Tab name", function(text)
      vim.api.nvim_tabpage_set_var(0, "name", text)
      vim.cmd "redrawtabline"
    end, "", 25, "󰓩 ")
  end, "Rename tab")
  map("<leader>bo", M.close_others, "Buffer Close others")
  map("<leader>bH", M.close_left, "Buffer Close Left")
  map("<leader>bL", M.close_right, "Buffer Close Right")
  map("<Tab>", ":bnext<CR>", "Buffer Cycle Next")
  map("<S-Tab>", ":bprev<CR>", "Buffer Cycle Prev")
end

-- Close commands kept from previous version
function M.close_others()
  local current = vim.api.nvim_get_current_buf()
  local bufs = get_buffers()
  for _, bufnr in ipairs(bufs) do
    if bufnr ~= current then vim.api.nvim_buf_delete(bufnr, { force = false }) end
  end
end

function M.close_left()
  local current = vim.api.nvim_get_current_buf()
  local bufs = get_buffers()
  for _, bufnr in ipairs(bufs) do
    if bufnr == current then break end
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end
end

function M.close_right()
  local current = vim.api.nvim_get_current_buf()
  local bufs = get_buffers()
  local found = false
  for _, bufnr in ipairs(bufs) do
    if found then vim.api.nvim_buf_delete(bufnr, { force = false }) end
    if bufnr == current then found = true end
  end
end

return M
