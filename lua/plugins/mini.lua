local wrap_keys = require "utils.wrap_keys"

vim.api.nvim_create_user_command("MiniNotifyHistory", function()
  require("mini.notify").show_history()
end, {})

return {
  {
    "echasnovski/mini.trailspace",
    keys = wrap_keys {
      { "<leader>tw", ':lua require("mini.trailspace").trim() <CR>', desc = "Trim Whitespace" },
    },
  }, -- Simple ways to trail whitespace useful when formatter is not working

  {
    "nvim-mini/mini.notify",
    event = { "LspAttach" },
    config = function()
      local notify_orig = vim.notify
      require("mini.notify").setup {
        lsp_progress = { enable = true },
      }
      vim.notify = notify_orig
    end,
  },

  {
    "nvim-mini/mini.splitjoin",
    keys = wrap_keys {
      { "gi", desc = "Toggle split object" },
      { "gj", desc = "Join the object" },
      { "gk", desc = "Split the object" },
    },
    opts = { mappings = { toggle = "gi", split = "gk", join = "gj" } },
  }, -- advanced join and split

  {
    "nvim-mini/mini.pairs",
    keys = {
      { "{", mode = { "i", "t", "c" } },
      { "[", mode = { "i", "t", "c" } },
      { "(", mode = { "i", "t", "c" } },
      { '"', mode = { "i", "t", "c" } },
      { "'", mode = { "i", "t", "c" } },
      { "`", mode = { "i", "t", "c" } },
    },
    config = { modes = { insert = true, command = true, terminal = false } },
  },

  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "o", "x" }, desc = "Mini Evaluate" },
      { "gm", mode = { "n", "o", "x" }, desc = "Mini Multiply" },
      { "cr", mode = { "n", "o", "x" }, desc = "Mini Replace" },
      { "gs", mode = { "n", "o", "x" }, desc = "Mini Sort" },
      { "gx", mode = { "n", "o", "x" }, desc = "Mini Exchange" },
    },
    opts = { replace = { prefix = "cr" } },
  }, -- sorting with motion

  {
    "nvim-mini/mini.comment",
    dependencies = { { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true } },
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o", "x" }, desc = "Comment toggle" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o", "x" }, desc = "Comment toggle blockwise" },
    },
    opts = {
      {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },

  {
    "echasnovski/mini.files",
    keys = wrap_keys {
      { "<leader>o", ':lua require("mini.files").open()<CR>', desc = "Open Mini Files" },
    },
    config = function()
      require("mini.files").setup {
        options = { permanent_delete = false },
        windows = {
          max_number = math.huge,
          preview = true,
          width_focus = 30,
          width_nofocus = 13,
          width_preview = 40,
        },
      }

      local au_group = vim.api.nvim_create_augroup("__mini", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        group = au_group,
        desc = "LSP Rename file",
        callback = function(event)
          local ok, rename = pcall(require, "lsp-file-operations.did-rename")
          if not ok then
            return
          end
          vim.defer_fn(function()
            require("mini.files").close()
          end, 1)
          vim.defer_fn(function()
            rename.callback { old_name = event.data.from, new_name = event.data.to }
          end, 1)
        end,
      })
    end,
  },
}
