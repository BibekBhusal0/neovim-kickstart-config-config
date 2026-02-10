local map = require "utils.map"

function RemoveAllComments()
  local bufnr = 0
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse(
    parser:lang(),
    [[
    (comment) @comment
  ]]
  )

  local comments = {}
  local is_visual = vim.fn.mode():find "[vV]"

  local start_row, end_row
  if is_visual then
    local visual_start = vim.fn.getpos "v"
    local visual_end = vim.fn.getpos "."
    start_row = visual_start[2] - 1
    end_row = visual_end[2] - 1
    if end_row < start_row then
      start_row, end_row = end_row, start_row
    end
  end

  for _, node in query:iter_captures(root, bufnr) do
    local node_start_row, node_start_col, node_end_row, node_end_col = node:range()
    if is_visual then
      if node_start_row >= start_row and node_end_row <= end_row then
        table.insert(comments, { node_start_row, node_start_col, node_end_row, node_end_col })
      end
    else
      table.insert(comments, { node_start_row, node_start_col, node_end_row, node_end_col })
    end
  end

  table.sort(comments, function(a, b)
    if a[1] == b[1] then
      return a[2] > b[2]
    end
    return a[1] > b[1]
  end)

  for _, range in ipairs(comments) do
    local range_start_row, range_start_col, range_end_row, range_end_col =
      range[1], range[2], range[3], range[4]

    if range_start_row == range_end_row then
      local line = vim.api.nvim_buf_get_lines(bufnr, range_start_row, range_start_row + 1, false)[1]
      local new_line = line:sub(1, range_start_col) .. line:sub(range_end_col + 1)
      vim.api.nvim_buf_set_lines(bufnr, range_start_row, range_start_row + 1, false, { new_line })
    else
      vim.api.nvim_buf_set_text(
        bufnr,
        range_start_row,
        range_start_col,
        range_end_row,
        range_end_col,
        {}
      )
    end
  end
end

vim.api.nvim_create_user_command("RemoveComments", RemoveAllComments, { range = true })

map("<leader>rc", RemoveAllComments, "Remove comments", { "n", "x" })
