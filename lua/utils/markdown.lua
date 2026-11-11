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

---Opening fence rows of every closed code block in the buffer
local function codeblock_starts(lines)
  local starts = {}
  local open_row, open_char, open_len = nil, nil, nil
  for i, line in ipairs(lines) do
    local char, len = parse_fence(line)
    if char then
      if not open_row then
        open_row, open_char, open_len = i, char, len
      elseif char == open_char and len >= open_len then
        table.insert(starts, open_row)
        open_row, open_char, open_len = nil, nil, nil
      end
    end
  end
  return starts
end

---Jump to the opening fence of a code block in the given direction
---@param forward boolean true for next, false for previous
local function jump_codeblock(forward)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local starts = codeblock_starts(lines)
  local target = nil
  if forward then
    for _, row in ipairs(starts) do
      if row > cursor then
        target = row
        break
      end
    end
  else
    -- Inside a block the cursor's own block counts, so prev lands on its fence.
    for i = #starts, 1, -1 do
      if starts[i] < cursor then
        target = starts[i]
        break
      end
    end
  end
  if not target then
    return
  end
  vim.cmd "normal! m'"
  vim.api.nvim_win_set_cursor(0, { target, 0 })
end

function M.next_codeblock()
  jump_codeblock(true)
end

function M.prev_codeblock()
  jump_codeblock(false)
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
