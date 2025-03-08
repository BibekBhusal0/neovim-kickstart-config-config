function get_diff()
  local diff = vim.fn.system 'git diff --no-ext-diff --staged'
  local m = {}
  if string.find(diff, '^error') then
    m.ok = false
    m.message = 'Git not initialized'
  elseif diff == '' then
    m.ok = false
    m.message = 'No changes made'
  else
    m.ok = true
    m.message = diff
  end
  return m
end
return get_diff
