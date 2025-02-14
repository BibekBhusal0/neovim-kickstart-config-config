local map = vim.api.nvim_set_keymap
return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
          require('gitsigns').setup()

          map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true, silent = true, desc = "Git Stage hunk" })
          map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { noremap = true, silent = true, desc = "Git Reset hunk" })
          map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { noremap = true, silent = true, desc = "Git Stage buffer" })
          map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { noremap = true, silent = true, desc = "Git Reset buffer" })
          map("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, silent = true, desc = "Git Preview hunk" })
          map("n", "<leader>gb", "<cmd>Gitsigns blame<CR>", { noremap = true, silent = true, desc = "Git Blame" })
          map("n", "<leader>gB", "<cmd>Gitsigns blame_line<CR>", { noremap = true, silent = true, desc = "Git Toggle line blame" })
          map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { noremap = true, silent = true, desc = "Git Diff this" })
          map("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true, desc = "Git toggle current line blame" })
          map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", { noremap = true, silent = true, desc = "Gitsigns toggle" })
        end
    },
    {
        'tpope/vim-fugitive',
        config = function ()
            map("n", "<leader>gp", "<cmd>Git push<CR>", { noremap = true, silent = true, desc = "Git push" })
        end
    }
}
