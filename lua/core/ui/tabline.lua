local M = {}

local ui_colors = require "core.ui.colors"
local icons = require "utils.icons"

local SL = icons.ui

-- Global function for mouse clicks
_G.TablineSwitchBuf = function(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

_G.TablineSwitchTab = function(tabnr)
  vim.api.nvim_set_current_tabpage(tabnr)
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

local function wrap(component, color_prefix, is_active, side, is_modified)
  local suffix = is_active and "Active" or "Inactive"
  local hl_base = "%#" .. color_prefix .. suffix .. "#"
  local hl_sep = "%#" .. color_prefix .. suffix .. "Sep#"
  
  -- User requested NOT to change color for modified, but we still need the indicator.
  -- The indicator is already in 'component'.

  local res = ""
  if side == "left" or side == "both" then
    res = hl_sep .. SL.sep_l
  else
    res = hl_base .. " "
  end
  res = res .. hl_base .. component
  if side == "right" or side == "both" then
    res = res .. hl_sep .. SL.sep_r
  else
    res = res .. hl_base .. " "
  end
  return res
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

local function get_icon_hl(icon_hl, is_active)
  if not icon_hl then return is_active and "TabLineActive" or "TabLineInactive" end
  
  local colors = ui_colors.colors
  local bg = is_active and colors.active_bg or colors.inactive_bg
  local fg = vim.api.nvim_get_hl_by_name(icon_hl, true).foreground
  
  if not fg then return icon_hl end -- fallback

  local hl_name = "TabLineIcon" .. icon_hl .. (is_active and "Active" or "Inactive")
  vim.api.nvim_set_hl(0, hl_name, { fg = string.format("#%06x", fg), bg = bg })
  return hl_name
end

function M.tabline()
  local bufnrs = get_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_tails = {}
  for _, bufnr in ipairs(bufnrs) do
    table.insert(all_tails, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
  end

  local tab_width = 20
  local items = {}
  local current_idx = 1

  for i, bufnr in ipairs(bufnrs) do
    if bufnr == current_buf then current_idx = i end
    
    local name = get_buffer_name(bufnr, all_tails)
    local is_active = bufnr == current_buf
    local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    local modified_icon = is_modified and " ●" or ""
    
    local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
    local icon, icon_hl = require("nvim-web-devicons").get_icon(name, extension, { default = true })
    
    local hl_icon = get_icon_hl(icon_hl, is_active)
    local hl_text = is_active and "TabLineActive" or "TabLineInactive"
    
    local content = string.format("%%#%s#%s %%#%s#%s%s", hl_icon, icon, hl_text, name, modified_icon)
    
    -- Account for %## hl groups in width calculation
    local display_width = vim.fn.strdisplaywidth(icon .. " " .. name .. modified_icon)
    if display_width > tab_width then
      content = string.format("%%#%s#%s %%#%s#%s...", hl_icon, icon, hl_text, string.sub(name, 1, tab_width - display_width + #name - 4))
    else
      content = content .. string.rep(" ", tab_width - display_width)
    end

    local item = string.format("%%%d@TablineSwitchBuf@%s%%X", bufnr, wrap(content, "TabLine", is_active, "both"))
    table.insert(items, item)
  end

  -- Overflow handling
  local available_width = vim.o.columns - 30 -- reserved for tabs and padding
  local total_needed = #items * (tab_width + 3) -- +3 for separators
  
  local res_buffers = ""
  if total_needed <= available_width then
    res_buffers = table.concat(items, " ")
  else
    -- Simple scrolling: ensure current_idx is visible
    local visible_count = math.floor(available_width / (tab_width + 3))
    local start_idx = math.max(1, current_idx - math.floor(visible_count / 2))
    local end_idx = math.min(#items, start_idx + visible_count - 1)
    if end_idx == #items then start_idx = math.max(1, end_idx - visible_count + 1) end

    local visible_items = {}
    if start_idx > 1 then table.insert(visible_items, SL.arrow_l .. " ") end
    for i = start_idx, end_idx do
      table.insert(visible_items, items[i])
    end
    if end_idx < #items then table.insert(visible_items, " " .. SL.arrow_r) end
    res_buffers = table.concat(visible_items, " ")
  end

  -- Tabs section (Pill shape)
  local tabs = vim.api.nvim_list_tabpages()
  local tab_res = {}
  if #tabs > 1 then
    local tab_parts = {}
    for i, tabpage in ipairs(tabs) do
      local is_active = tabpage == vim.api.nvim_get_current_tabpage()
      local name = i
      local ok, tab_name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "name")
      if ok and tab_name and tab_name ~= "" then name = tab_name end
      
      local hl_tab = is_active and "%#TabLineTabActive#" or "%#TabLineTabInactive#"
      table.insert(tab_parts, string.format("%%%d@TablineSwitchTab@%s%s%%X", tabpage, hl_tab, name))
    end
    
    local tab_pill = table.concat(tab_parts, " " .. SL.sep_thin .. " ")
    table.insert(tab_res, wrap(" " .. tab_pill .. " ", "TabLineTab", true, "both"))
  end

  return "  " .. res_buffers .. "%=" .. table.concat(tab_res, " ")
end

function M.rename_tab()
  require "utils.input"("Tab name", function(text)
    vim.api.nvim_tabpage_set_var(0, "name", text)
    vim.cmd "redrawtabline"
  end, "", 25, "󰓩 ")
end

function M.close_others()
  local current = vim.api.nvim_get_current_buf()
  local bufs = get_buffers()
  for _, bufnr in ipairs(bufs) do
    if bufnr ~= current then
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
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
    if found then
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
    if bufnr == current then found = true end
  end
end

function M.setup()
  vim.opt.tabline = "%!v:lua.require'core.ui.tabline'.tabline()"
  
  local map = require "utils.map"
  map("<leader>tr", M.rename_tab, "Rename tab")
  map("<leader>bo", M.close_others, "Buffer Close others")
  map("<leader>bH", M.close_left, "Buffer Close Left")
  map("<leader>bL", M.close_right, "Buffer Close Right")
  map("<Tab>", ":bnext<CR>", "Buffer Cycle Next")
  map("<S-Tab>", ":bprev<CR>", "Buffer Cycle Prev")
end

return M
