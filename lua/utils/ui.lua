local M = {}
local icons = require "utils.icons"
local SL = icons.ui

function M.wrap(component, hl_group, side)
  local hl_base = "%#" .. hl_group .. "#"
  local hl_sep = "%#" .. hl_group .. "Sep#"

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

function M.get_icon_hl(icon_hl, is_active)
  if not icon_hl then
    return is_active and "UIActive" or "UIInactive"
  end

  local base_group = is_active and "UIActive" or "UIInactive"
  local base_hl = vim.api.nvim_get_hl(0, { name = base_group, link = false })
  local bg = base_hl.bg

  local icon_hl_data = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })
  local fg = icon_hl_data.fg

  if not fg then
    return icon_hl
  end

  local hl_name = "UIIcon" .. icon_hl .. (is_active and "Active" or "Inactive")
  vim.api.nvim_set_hl(0, hl_name, {
    fg = string.format("#%06x", fg),
    bg = string.format("#%06x", bg),
  })
  return hl_name
end

return M
