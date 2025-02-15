local map = vim.keymap.set

return {
    {
        'tpope/vim-sleuth',               -- Detect tabstop and shiftwidth automatically
        'tpope/vim-rhubarb',              -- GitHub integration for vim-fugitive
        'folke/which-key.nvim',           -- Hints keybinds
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
    }, -- Autoclose parentheses, brackets, quotes, etc.
    {
        'windwp/nvim-ts-autotag',
        -- event = 'InsertEnter',
        -- config = function ()
        --     require('nvim-ts-autotag').setup()
        -- end,
    }, -- Autoclose HTML tags -- FIX: not working don't konw why
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('todo-comments').setup()
            map('n', '<leader>sc', '<cmd>TodoTelescope<CR>', { desc = 'Search Todo' })
            map('n', '<leader>ll', '<cmd>TodoLocList<CR>', { desc = 'Todo Loc List' })
        end,
        opts = {
            signs = false,
            keywards = {
                COPIED_FROM = { icon = " ", color = "hint", alt = { "COPY", "COPIED", "CREDIT" } },
            }
        },
    }, -- Highlight todo, notes, etc in comments
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }, -- High-performance color highlighter
    {
        'rmagatti/auto-session',
        lazy = false,
        config = function()
            require('auto-session').setup {
                map('n', '<leader>ssf', '<cmd>SessionSearch<CR>', { desc = 'Search Session' }),
                map('n', '<leader>sss', '<cmd>SessionSave<CR>', { desc = 'Save Session' }),
                map('n', '<leader>ssr', '<cmd>SessionRestore<CR>', { desc = 'Restore Session' }),
                map('n', '<leader>ssR', '<cmd>SessionDisableAutoSave<CR>', { desc = 'Toggle Session Autosave' }),
            }
        end
    }, -- session manager
    {
        'numToStr/Comment.nvim',
        opts = {},
        config = function()
            local opts = { noremap = true, silent = true }
            map('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
            map('n', '<C-c>', require('Comment.api').toggle.linewise.current, opts)
            map('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
            map('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
            map('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
            map('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
        end,
    }, -- Easily comment visual regions/lines
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            indent = {
                char = '▏',
            },
            scope = {
                show_start = false,
                show_end = false,
                show_exact_scope = false,
            },
            exclude = {
                filetypes = {
                    'help',
                    'startify',
                    'dashboard',
                    'packer',
                    'neogitstatus',
                    'NvimTree',
                    'Trouble',
                },
            },
        },
    }, -- Better indentations
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    }, -- Git integration (only works if lazy git installed in system)



}
