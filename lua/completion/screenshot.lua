M = {}

local theme_prefix = "theme="
local commands = { "html", "clip", "disk", "hide_line_numbers", "hide_tabs", theme_prefix }
local themes = { "crimson", "candy", "brooze", "sunset", "meadow", "bubbly", "rainddop", "mono" }

---@param argLead string
---@param cmdLine string
---@return string candidates_string
M.complete_args = function(argLead, cmdLine)
  local candidates = {}
  if string.find(argLead, theme_prefix, 1, true) then
    for _, theme in ipairs(themes) do
      table.insert(candidates, theme_prefix .. theme)
    end
  else
    for _, cmd in ipairs(commands) do
      local added = cmdLine:find(cmd, 1, true) ~= nil
      if not added then
        table.insert(candidates, cmd)
      end
    end
  end

  return table.concat(candidates, "\n")
end

return M
