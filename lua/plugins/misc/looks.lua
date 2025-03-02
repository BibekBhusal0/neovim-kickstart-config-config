local map = require("utils.map")

return {
    {
        "norcalli/nvim-colorizer.lua",
        event = "InsertEnter",
        config = function() require("colorizer").setup() end,
    }, -- High-performance color highlighter

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufNewFile", "BufReadPost" },
        opts = {
            indent = { char = "▏" },
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
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({ virtual_text = false, })
            vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
            map('<leader>lt' ,require("lsp_lines").toggle , "Toggle LSP line" )
        end,
        event = "LspAttach"
    }, -- Better diagnostic messages 

    {
        'luukvbaal/statuscol.nvim',
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            local builtin = require('statuscol.builtin')
            return {
                setopt = true,
                segments = {
                    { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa', auto = true },
                    { text = { builtin.lnumfunc, '' }, click = 'v:lua.ScLa', auto = true },
                    {
                        sign = { namespace = { 'diagnostic/signs' }, auto = true },
                        click = 'v:lua.ScSa',
                    },
                    { sign = { namespace = { 'gitsigns' }, }, click = 'v:lua.ScSa' },
                },
            }
        end,
    }, -- changes the status column which appears in left side

    {
        'petertriho/nvim-scrollbar', 
        event = { "BufNewFile", "BufReadPost" },
        dependencies = {
            'kevinhwang91/nvim-hlslens',
            config = function () 
                require('scrollbar.handlers.search').setup({ calm_down = true, nearest_only = true })
                map('n', [[<Cmd>execute('normal! ' . v:count1 . 'nzz')<CR><Cmd>lua require('hlslens').start()<CR>]] , "Find Next" )
                map('N',  [[<Cmd>execute('normal! ' . v:count1 . 'Nzz')<CR><Cmd>lua require('hlslens').start()<CR>]] , "Find Previous" )
                map('*', [[*<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Under Cursor')
                map('#', [[#<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Before Cursor')
                map('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Under Cursor')
                map('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], 'Find Word Before Cursor')
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

    {
        "folke/twilight.nvim",
        cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
        keys = {  {"<leader>F", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
        opts = { context = 20 }
    } , -- dim inactive code 

    -- ╭─────────────────────────────────────────────────────────╮
    -- │                       ANIMATIONS                        │
    -- ╰─────────────────────────────────────────────────────────╯
    {
        "sphamba/smear-cursor.nvim",
        event = { "CursorHold", "CursorHoldI" },
        opts = {},
        config = function()
            local sm = require("smear_cursor")
            sm.setup({
                cursor_color = "#ff8800",
                stiffness = 0.6,
                trailing_stiffness = 0.3,
                distance_stop_animating = 0.5,
                hide_target_hack = true,
                gamma = 1,
            })
            sm.enabled = true
            map("<leader>tc", ":SmearCursorToggle<CR>", "Toggle Smear Cursor")
        end
    }, -- cursor animation 

    {
        "karb94/neoscroll.nvim",
        opts = { hide_cursor = true },
        event = { "BufNewFile", "BufReadPost" },
    }, -- Smooth scrolling
}
