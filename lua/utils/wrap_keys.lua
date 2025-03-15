local function wrap_keys(keys)
  for _, key in ipairs(keys) do
    key.silent = true
  end
  return keys
end
return wrap_keys
