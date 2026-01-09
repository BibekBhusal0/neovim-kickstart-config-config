local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

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
  for _, node in query:iter_captures(root, bufnr) do
    local start_row, start_col, end_row, end_col = node:range()
    table.insert(comments, { start_row, start_col, end_row, end_col })
  end

  table.sort(comments, function(a, b)
    if a[1] == b[1] then
      return a[2] > b[2]
    end
    return a[1] > b[1]
  end)

  for _, range in ipairs(comments) do
    local start_row, start_col, end_row, end_col = range[1], range[2], range[3], range[4]

    if start_row == end_row then
      local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
      local new_line = line:sub(1, start_col) .. line:sub(end_col + 1)
      vim.api.nvim_buf_set_lines(bufnr, start_row, start_row + 1, false, { new_line })
    else
      vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, {})
    end
  end
end

map("<leader>rc", RemoveAllComments, "Remove all comments")

return {
  {

    {
      "LudoPinelli/comment-box.nvim",
      keys = wrap_keys {
        { "<leader>CB", ":CBlcbox<CR>", desc = "Comment box", mode = { "n", "v" } },
        { "<leader>CL", ":CBlcline<CR>", desc = "Comment Line", mode = { "n", "v" } },
      },
      cmd = {
        "CBllbox",
        "CBllbox",
        "CBlcbox",
        "CBlrbox",
        "CBccbox",
        "CBcrbox",
        "CBcrbox",
        "CBrlbox",
        "CBrcbox",
        "CBrrbox",
        "CBalbox",
        "CBacbox",
        "CBarbox",
        "CBraline",
        "CBlcline",
        "CBlrline",
        "CBccline",
        "CBcrline",
        "CBcrline",
        "CBrlline",
        "CBrcline",
        "CBrrline",
        "CBcatalog",
      },
      opts = {},
      -- ╭─────────────────────────────────────────────────────────╮
      -- │                Makes comments like this                 │
      -- ╰─────────────────────────────────────────────────────────╯
    },

    {
      "folke/todo-comments.nvim",
      event = { "BufNewFile", "BufReadPost" },
      keys = wrap_keys {
        {
          "<leader>fc",
          ":TodoTelescope<CR>",
          desc = "Todo Search Telescope",
        },
        { "<leader>cT", ":Trouble todo<CR>", desc = "Todo Loc List" },
      },
      config = function()
        require("todo-comments").setup { signs = false }
        local todos = {
          t = {},
          -- T = { 'TODO' },
          -- F = { 'FIX' },
          -- W = { 'WARN', 'WARNING' },
          -- H = { 'HACK' },
          -- N = { 'NOTE' },
        }
        for k, p in pairs(todos) do
          local prev = function()
            require("todo-comments").jump_prev { keywords = p }
          end
          local next = function()
            require("todo-comments").jump_next { keywords = p }
          end
          local name = #p == 0 and "todo comment" or p[1]
          map("]" .. k, next, "Jump Next " .. name, { "n", "x", "o" })
          map("[" .. k, prev, "Jump Prev " .. name, { "n", "x", "o" })
        end
      end,
    }, -- WARNING: Highlights todo, notes, etc in comments
  },
}
