---Wrap keys, Makes sure the keys are silenced
---@param keys table
---@return table
local function wrap_keys(keys)
  for _, key in ipairs(keys) do
    key.silent = true
  end
  return keys
end
return wrap_keys
