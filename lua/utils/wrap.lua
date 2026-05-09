local function wrap(component, is_active, side)
  local SL = require("utils.icons").seperators
  local hl_group = is_active and "UIActive" or "UIInactive"
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

return wrap
