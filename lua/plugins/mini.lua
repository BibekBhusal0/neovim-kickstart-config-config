return {
  {
    "nvim-mini/mini.trailspace",
    keys = {
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
    "nvim-mini/mini.operators",
    keys = {
      { "cr", mode = { "n", "o", "x" }, desc = "Mini Replace" },
      { "g=", mode = { "n", "o", "x" }, desc = "Mini Evaluate" },
      { "gm", mode = { "n", "o", "x" }, desc = "Mini Multiply" },
      { "gs", mode = { "n", "o", "x" }, desc = "Mini Sort" },
      { "gx", mode = { "n", "o", "x" }, desc = "Mini Exchange" },
    },
    opts = { replace = { prefix = "cr" } },
  }, -- sorting with motion

  {
    "nvim-mini/mini.files",
    keys = {
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
          require("plugins.manager").load_plugin "nvim-lsp-file-operations"
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
