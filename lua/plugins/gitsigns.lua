return {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()

      local map = vim.api.nvim_set_keymap
      map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true, silent = true, desc = "Stage hunk" })
      map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { noremap = true, silent = true, desc = "Reset hunk" })
      map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { noremap = true, silent = true, desc = "Stage buffer" })
      map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { noremap = true, silent = true, desc = "Reset buffer" })
      map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, silent = true, desc = "Preview hunk" })
      map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { noremap = true, silent = true, desc = "Blame line" })
      map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true, desc = "Toggle current line blame" })
      map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { noremap = true, silent = true, desc = "Diff this" })
      map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", { noremap = true, silent = true, desc = "Gitsigns toggle" })
    end,
  }
