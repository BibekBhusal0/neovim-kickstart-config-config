local map = require "utils.map"
local sc_utils = require "utils.screenshot"

function RemoveAllComments(o)
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
  local range
  if o.range and o.range > 0 and o.line1 and o.line2 then
    range = { start_line = o.line1, end_line = o.line2 }
  else
    range = { start_line = 1, end_line = vim.fn.line "$" }
  end
  local start_row = range.start_line - 1
  local end_row = range.end_line - 1

  for _, node in query:iter_captures(root, bufnr) do
    local node_start_row, node_start_col, node_end_row, node_end_col = node:range()
    if node_start_row >= start_row and node_end_row <= end_row then
      table.insert(comments, { node_start_row, node_start_col, node_end_row, node_end_col })
    end
  end

  table.sort(comments, function(a, b)
    if a[1] == b[1] then
      return a[2] > b[2]
    end
    return a[1] > b[1]
  end)

  for _, r in ipairs(comments) do
    local range_start_row, range_start_col, range_end_row, range_end_col = r[1], r[2], r[3], r[4]

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

local function parse(args)
  if type(args) == "string" then
    args = vim.split(args, " ")
  end
  local result = {}
  for _, arg in ipairs(args) do
    local i = arg:find("=", 1, true)
    if not i then
      result[arg] = true
    else
      local key = arg:sub(1, i - 1)
      local value = arg:sub(i + 1)
      result[key] = value
    end
  end
  return result
end

vim.api.nvim_create_user_command("S", function(o)
  local opts = parse(o.fargs)
  local type = "image"
  local range
  if o.range and o.range > 0 and o.line1 and o.line2 then
    range = { start_line = o.line1, end_line = o.line2 }
  else
    range = { start_line = 1, end_line = vim.fn.line "$" }
  end
  local snapConfig = { additional_template_data = { theme = opts.theme or "crimson" } }

  if opts.html then
    type = "html"
  end
  if opts.clip then
    snapConfig.copy_to_clipboard = { [type] = true }
  else
    snapConfig.copy_to_clipboard = { [type] = false }
  end
  if opts.disk == false then
    snapConfig.save_to_disk = { [type] = false }
  else
    if opts.disk == true then
      snapConfig.save_to_disk = { [type] = true }
    else
      snapConfig.save_to_disk = { [type] = not snapConfig.copy_to_clipboard[type] }
    end
  end
  if opts.hide_line_numbers ~= true then
    snapConfig.additional_template_data.line_number = {
      start = range.start_line - 1,
      width = #tostring(range.end_line - 1),
      show = true,
    }
  end
  if opts.hide_tabs ~= true then
    snapConfig.additional_template_data.file_name = sc_utils.get_file_name()
  end
  if opts.hide_git ~= true then
    snapConfig.additional_template_data.git = sc_utils.get_repo()
  end

  require("snap.config").set(snapConfig)
  local Runner = require "snap.runner"
  Runner.run { range = range, type = type }

  -- Reset template after 2 sec
  vim.defer_fn(function()
    require("snap.config").set { additional_template_data = sc_utils.defaultTemplate }
  end, 2000)
end, {
  nargs = "*",
  range = true,
  complete = "custom,v:lua.require'completion.screenshot'.complete_args",
})

vim.api.nvim_create_user_command("RemoveComments", RemoveAllComments, { range = true })
map("<leader>rc", ":RemoveComments<Cr>", "Remove comments", { "n", "x" })
map("<leader>sc", ":S clip<Cr>", "Screenshot to clipboard", { "n", "x" })
map("<leader>sC", ":S<Cr>", "Screenshot to disk", { "n", "x" })
