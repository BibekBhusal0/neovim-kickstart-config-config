local M = {}

local function parse_fence(line)
  local fence = line:match "^%s*(```+)%s*%S*%s*$" or line:match "^%s*(~~~+)%s*%S*%s*$"
  if fence then
    return fence:sub(1, 1), #fence
  end
  -- Fallback for info strings with spaces (e.g. ``` python {.foo})
  fence = line:match "^%s*(```+)" or line:match "^%s*(~~~+)"
  if fence then
    return fence:sub(1, 1), #fence
  end
  return nil
end

function M.copy_codeblock()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local open_row, open_char, open_len = nil, nil, nil
  for i = 1, cursor do
    local char, len = parse_fence(lines[i])
    if char then
      if not open_row then
        open_row, open_char, open_len = i, char, len
      elseif char == open_char and len >= open_len then
        if i < cursor then
          open_row, open_char, open_len = nil, nil, nil
        end
      end
    end
  end
  if not open_row then
    vim.notify("Not inside a code block", vim.log.levels.WARN)
    return
  end
  local close_row = nil
  for j = open_row + 1, #lines do
    local char, len = parse_fence(lines[j])
    if char == open_char and len and len >= open_len then
      close_row = j
      break
    end
  end
  if not close_row or cursor > close_row then
    vim.notify("Not inside a code block", vim.log.levels.WARN)
    return
  end
  local content = {}
  for i = open_row + 1, close_row - 1 do
    table.insert(content, lines[i])
  end
  if #content == 0 then
    vim.notify("Code block is empty", vim.log.levels.WARN)
    return
  end
  local text = table.concat(content, "\n")
  vim.fn.setreg("+", text .. "\n")
  vim.fn.setreg('"', text .. "\n")
  vim.notify(string.format("Copied %d lines from code block", #content), vim.log.levels.INFO)
end

return M
