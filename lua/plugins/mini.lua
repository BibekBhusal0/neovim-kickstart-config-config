local wrap_keys = require "utils.wrap_keys"

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
    opts = { "nvim-mini/mini.notify", opts = { lsp_progress = { enable = true } } },
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
