return {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    },
    config = function()
      local gitsigns = require('gitsigns')

      -- Key mappings using g_ prefix
      local map = vim.api.nvim_set_keymap
      map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true, silent = true, desc = "Stage hunk" })
      map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { noremap = true, silent = true, desc = "Reset hunk" })
      map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { noremap = true, silent = true, desc = "Stage buffer" })
      map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { noremap = true, silent = true, desc = "Reset buffer" })
      map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, silent = true, desc = "Preview hunk" })
      map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { noremap = true, silent = true, desc = "Blame line" })
      map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true, desc = "Toggle current line blame" })
      map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { noremap = true, silent = true, desc = "Diff this" })
    end,
  }
