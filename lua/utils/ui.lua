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
  return is_active and "UIActive" or "UIInactive"
end

return M
