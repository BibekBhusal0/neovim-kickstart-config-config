local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

return {
  {
    {
      "numToStr/Comment.nvim",
      dependencies = {
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          config = function()
            local ts_context_commentstring =
              require "ts_context_commentstring.integrations.comment_nvim"
            require("Comment").setup { pre_hook = ts_context_commentstring.create_pre_hook() }
          end,
        },
      },
      keys = {
        { "gcc", mode = "n", desc = "Comment toggle current line" },
        { "gc", mode = { "n", "o", "x" }, desc = "Comment toggle" },
        { "gbc", mode = "n", desc = "Comment toggle current block" },
        { "gb", mode = { "n", "o", "x" }, desc = "Comment toggle blockwise" },
      },
      opts = {},
    }, -- Easily comment visual regions/lines

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

  {
    "jeangiraldoo/codedocs.nvim",
    keys = wrap_keys {
      {
        "<Leader>CD",
        ":Codedocs<CR>",
        desc = "Toggle comment docs",
      },
    },
  }, -- Easy to add Doc comments in different languages
}
