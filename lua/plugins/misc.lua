local map = require("utils.map")

return {
    { -- hints, will remove soon
        {
            "folke/which-key.nvim", 
            cmd = "WhichKey", -- disable which key by default
            -- keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
            -- event = "VeryLazy",
        },   -- Hints keybinds
        {
            "smartinellimarco/nvcheatsheet.nvim",
            lazy = true,
            keys = { { "<leader>ch", ':lua require("nvcheatsheet").toggle()<CR>', desc = "Toggle Cheatsheet" } },
            config = function() require('nvcheatsheet').setup(require('utils.cheatsheet')) end
        }, --  cheatsheet
    },

    {
-- ╭─────────────────────────────────────────────────────────╮
-- │                         Editing                         │
-- ╰─────────────────────────────────────────────────────────╯
        {
            "kylechui/nvim-surround",
            event = { "InsertEnter"},
            config = function() require("nvim-surround").setup({}) end
        }, -- change brackets, quotes and surrounds 
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = true,
        }, -- Autoclose parentheses, brackets, quotes, etc.
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
            'nguyenvukhang/nvim-toggler',
            keys = { { '<leader>tt', ':lua require("nvim-toggler").toggle() <Cr>', desc = "Toggle Value"}},
            config = function () 
                require("nvim-toggler").setup({ remove_default_keybinds = true })
            end
        }, -- Toggle between true and false ; more
        { 
            "luckasRanarison/tailwind-tools.nvim",
            opts = {} ,
            ft = {"html" , "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte"},
        }, -- tailwind color highlights 
        {
            'jakewvincent/mkdnflow.nvim',
            ft = 'markdown',
            config = function()
                require('mkdnflow').setup({
                    mappings = {
                        MkdnEnter = {{'n', 'v'}, '<CR>'},
                        MkdnTab = false,
                        MkdnSTab = false,
                        MkdnNextLink = {'n', ']l'},
                        MkdnPrevLink = {'n', '[l'},
                        MkdnNextHeading = {'n', ']]'},
                        MkdnPrevHeading = {'n', '[['},
                        MkdnGoBack = {'n', '<BS>'},
                        MkdnGoForward = {'n', '<Del>'},
                        MkdnCreateLink = false, -- see MkdnEnter
                        MkdnCreateLinkFromClipboard = {{'n', 'v'}, '<A-p>'}, -- see MkdnEnter
                        MkdnFollowLink = false, -- see MkdnEnter
                        MkdnDestroyLink = {'n', '<M-CR>'},
                        MkdnTagSpan = {'v', '<M-CR>'},
                        MkdnMoveSource = {'n', '<F2>'},
                        MkdnYankAnchorLink = {'n', 'yaa'},
                        MkdnYankFileAnchorLink = {'n', 'yfa'},
                        MkdnIncreaseHeading = {'n', '+'},
                        MkdnDecreaseHeading = {'n', '-'},
                        MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
                        MkdnNewListItem = false,
                        MkdnNewListItemBelowInsert = {'n', 'o'},
                        MkdnNewListItemAboveInsert = {'n', 'O'},
                        MkdnExtendList = false,
                        MkdnUpdateNumbering = {'n', '<leader>nn'},
                        MkdnTableNextCell = {'i', ']c'},
                        MkdnTablePrevCell = {'i', '[c'},
                        MkdnTableNextRow = false,
                        MkdnTablePrevRow = {'i', '<M-CR>'},
                        MkdnTableNewRowBelow = {'n', '<C-i>r'},
                        MkdnTableNewRowAbove = {'n', '<C-i>R'},
                        MkdnTableNewColAfter = {'n', '<C-i>c'},
                        MkdnTableNewColBefore = {'n', '<C-i>C'},
                        MkdnFoldSection = {'n', 'f'},
                        MkdnUnfoldSection = {'n', '<leader>F'}
                    }
                })
            end
        }, -- Better editing in markdown 
        {
            "gregorias/coerce.nvim",
            event = {"BufNewFile", "BufReadPost"},
            tag = 'v4.1.0',
            config = true,
        }, -- Changing case easily
        { 'bennypowers/splitjoin.nvim',
            keys = {
              { 'gj', function() require'splitjoin'.join() end, desc = 'Join the object under cursor' },
              { 'g,', function() require'splitjoin'.split() end, desc = 'Split the object under cursor' },
            },
        }, -- easy join and split 
        { -- comments 
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
                'LudoPinelli/comment-box.nvim', 
                event = { "BufNewFile", "BufReadPost" },
                config = function() require('comment-box').setup() end
                -- ╭─────────────────────────────────────────────────────────╮
                -- │                Makes comments like this                 │
                -- ╰─────────────────────────────────────────────────────────╯
            },
            {
                "folke/todo-comments.nvim",
                event = { "BufNewFile", "BufReadPost" },
                keys = {
                    { "<leader>sc", "<cmd>TodoTelescope<CR>", desc = "Todo Search Telescope" },
                    { "<leader>ll", "<cmd>TodoLocList<CR>",   desc = "Todo Loc List" },
                },
                config = function()
                    local todo = require("todo-comments")
                    todo.setup({ signs = false, })
                    map("]t", todo.jump_next, "Next todo comment")
                    map("[t", todo.jump_prev, "Previous todo comment")
                    local comments = {"FIX", "WARN", "TODO", "HACK", "NOTE"}
                    for _, comment in ipairs(comments) do 
                        map ("[" .. comment:sub(1,1), function() todo.jump_prev({ keywords = {comment} }) end , "Previous " .. comment)
                        map( ']' .. comment:sub(1,1), function() todo.jump_next({ keywords = {comment} }) end , "Next " .. comment)
                    end
                end,
            }, -- Highlight todo, notes, etc in comments
        }
    },
    {
-- ╭─────────────────────────────────────────────────────────╮
-- │                     JUST FOR LOOKS                      │
-- ╰─────────────────────────────────────────────────────────╯
        {
            "norcalli/nvim-colorizer.lua",
            event = "InsertEnter",
            config = function() require("colorizer").setup() end,
        }, -- High-performance color highlighter
        {
            "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            event = "LspAttach"
            config = function()
                require("lsp_lines").setup()
                vim.diagnostic.config({ virtual_text = false, })
                vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
                map('<leader>lt' ,require("lsp_lines").toggle , "Toggle LSP line" )
            end,
        }, -- Better diagnostic messages 
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
                    map("<Esc>", '<Cmd>noh<CR>', 'Clear Highlight')

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
            keys = {  {"<leader>T", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
            opts = { context = 20 }
        } , -- dim inactive code 
        {
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
                opts = { hide_cursor = false },
                event = { "BufNewFile", "BufReadPost" },
            }, -- Smooth scrolling
        },
    }, 
    {
        "quentingruber/pomodoro.nvim",
        keys = {
            {'<leader>ps', ':PomodoroStart<CR>', desc = 'Pomodoro Start'},
            {'<Leader>pS', ':PomodoroStop<CR>', desc = 'Pomodoro Stop'},
            {'<Leader>pu', ':PomodoroUI<CR>', desc = 'Pomodoro UI'},
            {'<Leader>pd', ':PomodoroDelayBreak<CR>', desc = 'Pomodoro Delay Break'},
            {'<Leader>pb', ':PomodoroForceBreak<CR>', desc = 'Pomodoro Force Break'},
            {'<Leader>pB', ':PomodoroSkipBreak<CR>', desc = 'Pomodoro Skip Break'},
        } ,
        opts = {
            start_at_launch = false,
            work_duration = 25,
            break_duration = 5,
            delay_duration = 1,
            long_break_duration = 15,
            breaks_before_long = 4,
        },
    }, -- Simple pomodoro timer
    {
        'backdround/global-note.nvim',
        keys = {
            {"<leader>ng", "<cmd>GlobalNote<cr>", desc = "Global Note"},
            {"<leader>np", "<cmd>ProjectNote<cr>", desc = "Project Note"},
        },
        config = function () 
            local gloabl_note = require('global-note')
            local get_project_name = function()
                local project_directory, err = vim.loop.cwd()
                if project_directory == nil then
                    vim.notify(err, vim.log.levels.WARN)
                    return nil
                end

                local project_name = vim.fs.basename(project_directory)
                if project_name == nil then
                    vim.notify("Unable to get the project name", vim.log.levels.WARN)
                    return nil
                end

                return project_name
            end

            gloabl_note.setup({
                additional_presets = {
                    project_local = {
                        command_name = "ProjectNote",
                        filename = function() return get_project_name() .. ".md" end,
                        title = "Project note",
                    },
                }
            })
        end
    }, -- note taking 
}
