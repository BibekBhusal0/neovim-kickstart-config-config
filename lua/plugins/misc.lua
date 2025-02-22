local map = require("utils.map")

return {
    {
        "folke/which-key.nvim", -- Hints keybinds
        event = "VeryLazy",
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    }, -- Autoclose parentheses, brackets, quotes, etc.
    {
        "folke/todo-comments.nvim",
        event = { "BufNewFile", "BufReadPost" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>sc", "<cmd>TodoTelescope<CR>", desc = "Todo Search Telescope" },
            { "<leader>ll", "<cmd>TodoLocList<CR>",   desc = "Todo Loc List" },
        },
        config = function()
            require("todo-comments").setup({ signs = false, })
        end,
    }, -- Highlight todo, notes, etc in comments
    {
        "norcalli/nvim-colorizer.lua",
        event = "InsertEnter",
        config = function()
            require("colorizer").setup()
        end,
    }, -- High-performance color highlighter
    {
        "numToStr/Comment.nvim",
        event = {"BufNewFile", "BufReadPost"},
        opts = {},
        config = function()
            local toggleComment = require("Comment.api").toggle.linewise.current
            local toggleCommentVisual = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>"
            local keys = { '/', '_', 'c' }
            for _, key in ipairs(keys) do
                map("<C-" .. key .. ">", toggleComment, 'Toggle Comment', { "n", "i" })
                map("<C-" .. key .. ">", toggleCommentVisual, 'Toggle Comment', 'v')
            end
        end,
    }, -- Easily comment visual regions/lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufNewFile", "BufReadPost" },
        opts = {
            indent = {
                char = "▏",
            },
            scope = {
                show_start = false,
                show_end = false,
                show_exact_scope = false,
            },
            exclude = {
                filetypes = {
                    "help",
                    "startify",
                    "dashboard",
                    "packer",
                    "neogitstatus",
                    "NvimTree",
                    "Trouble",
                    "alpha"
                },
            },
        },
    }, -- Better indentations
    {
        "nvzone/timerly",
        dependencies = { "nvzone/volt", },
        cmd = "TimerlyToggle",
        lazy = true,
        keys = { { "<leader>tf", "<cmd>TimerlyToggle<CR>", desc = "Toggle Timerly" } }
    }, -- Simple Timer
    {
        'luukvbaal/statuscol.nvim',
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            local builtin = require('statuscol.builtin')

            return {
                setopt = true,
                segments = {
                    {
                        text = { builtin.foldfunc, ' ' },
                        click = 'v:lua.ScFa',
                        auto = true,
                    },
                    {
                        text = { builtin.lnumfunc, '' },
                        click = 'v:lua.ScLa',
                        auto = true,
                    },
                    {
                        sign = { namespace = { 'diagnostic/signs' }, auto = true },
                        click = 'v:lua.ScSa',
                    },
                    {
                        sign = { namespace = { 'gitsigns' }, },

                        click = 'v:lua.ScSa',
                    },
                },
            }
        end,
    }, -- changes the status column which appears in left side
    {
        "smartinellimarco/nvcheatsheet.nvim",
        lazy = true,
        keys = { { "<leader>ch", ':lua require("nvcheatsheet").toggle()<CR>', desc = "Toggle Cheatsheet" } },
        config = function()
            require('nvcheatsheet').setup(require('utils.cheatsheet'))
        end
    }, --  cheatsheet
    {
        'petertriho/nvim-scrollbar', 
        event = { "BufNewFile", "BufReadPost" },
        dependencies = {
            'kevinhwang91/nvim-hlslens',
            config = function () 
                require('scrollbar.handlers.search').setup({
                    calm_down = true ,
                    nearest_only = true,
                })
                map('n', [[<Cmd>execute('normal! ' . v:count1 . 'nzz')<CR><Cmd>lua require('hlslens').start()<CR>]] , "Find Next" )
                map('N',  [[<Cmd>execute('normal! ' . v:count1 . 'Nzz')<CR><Cmd>lua require('hlslens').start()<CR>]] , "Find Previous" )
                map('*', [[*<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Under Cursor')
                map('#', [[#<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Before Cursor')
                map('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Under Cursor')
                map('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Before Cursor')
                map("<leader>.", '<Cmd>noh<CR>', 'Clear Highlight')
                
            end
        },
        config = function()
            require('scrollbar').setup({
                show_in_active_only = true,
                hide_if_all_visible = true,
                handlers ={
                    cursor = true,
                    diagnostic = true,
                    gitsigns = true,
                    handle = true,
                }
            })
        end
    },  -- scrollbar showing gitsigns and diagnostics
}
