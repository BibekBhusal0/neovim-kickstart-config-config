local map = require("utils.map")

local comment_keys = {} 
local toggleComment = ':require("Comment.api").toggle.linewise.current()<CR>'
local toggleCommentVisual = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>"
local keys = { '/', '_', 'c' }
for _, key in ipairs(keys) do
    table.insert(comment_keys, { "<C-" .. key .. ">", toggleComment, 'Toggle Comment', { "n", "i" } })
    table.insert(comment_keys, { "<C-" .. key .. ">", toggleCommentVisual, 'Toggle Comment', 'v' })
end

local webDev =  {"html" , "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte"}

return {
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
        "windwp/nvim-ts-autotag",
        config = true,
        ft = webDev,
    }, -- Autoclose HTML tags 

    {
        'mg979/vim-visual-multi',
        event = { "BufNewFile", "BufReadPost"}, 
        config  = function () 
            local hlslens = require('hlslens')
            if hlslens then
                local overrideLens = function(render, posList, nearest, idx, relIdx)
                    local _ = relIdx
                    local lnum, col = unpack(posList[idx])
                    local text, chunks
                    if nearest then
                        text = ('[%d/%d]'):format(idx, #posList)
                        chunks = {{' ', 'Ignore'}, {text, 'VM_Extend'}}
                    else
                        text = ('[%d]'):format(idx)
                        chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end
                local lensBak
                local config = require('hlslens.config')
                local gid = vim.api.nvim_create_augroup('VMlens', {})
                vim.api.nvim_create_autocmd('User', {
                    pattern = {'visual_multi_start', 'visual_multi_exit'},
                    group = gid,
                    callback = function(ev)
                        if ev.match == 'visual_multi_start' then
                            lensBak = config.override_lens
                            config.override_lens = overrideLens
                        else
                            config.override_lens = lensBak
                        end
                        hlslens.start()
                    end
                })
            end
        end
    }, -- multi line editing 

    {
        'nguyenvukhang/nvim-toggler',
        keys = { { '<leader>tt', ':lua require("nvim-toggler").toggle() <Cr>', desc = "Toggle Value"}},
        config = function () 
            require("nvim-toggler").setup({ remove_default_keybinds = true })
        end
    }, -- Toggle between true and false ; more

    { 
        "luckasRanarison/tailwind-tools.nvim",
        ft = webDev,
        dependencies = {
            'razak17/tailwind-fold.nvim',
            opts = { ft = webDev },
        },
        config = function ()
            require('tailwind-tools').setup({})
            map("<leader>Tf", ":TailwindFoldToggle<CR>", "Tailwind Fold Toggle")
            map("<leader>TS", ":TailwindSort<CR>", "Tailwind Sort")
            map("<leader>Ts", ":TailwindSortSelection<CR>", "Tailwind Sort" , "v")
            map("<leader>Tc", ":TailwindColorToggle<CR>", "Tailwind Color Toggle")
            map("]c", ":TailwindNextClass<CR>", "Tailwind Next Class", {'n', 'v'})
            map("[c", ":TailwindPrevClass<CR>", "Tailwind Previous Class", {'n', 'v'})
            map("<leader>st", ":Telescope tailwind classes<CR>", "Search Tailwind Classes")
            map("<leader>Ts", ":Telescope tailwind classes<CR>", "Tailwind search")
        end
    }, -- tailwind color highlights folds and more

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
        event = { "BufNewFile", "BufReadPost" },
        tag = 'v4.1.0',
        config = true,
    }, -- Changing case easily

    { 'bennypowers/splitjoin.nvim',
        keys = {
            { 'gj', function() require'splitjoin'.join() end, desc = 'Join the object under cursor' },
            { 'g,', function() require'splitjoin'.split() end, desc = 'Split the object under cursor' },
        },
    }, -- advanced join and split 

    { -- comments 
        {
            "numToStr/Comment.nvim",
            keys = comment_keys,
            dependencies = {
                "JoosepAlviste/nvim-ts-context-commentstring",
            },
            opts = {},
            config = function()
                require('Comment').setup {
                    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                }
            end,
        }, -- Easily comment visual regions/lines

        {
            'LudoPinelli/comment-box.nvim', 
            cmd = {
                "CBllbox",
                "CBllbox",
                "CBlcbox",
                "CBlrbox",
                "CBccbox",
                "CBcrbox",
                "CBcrbox",
                "CBrlbox",
                "CBrcbox",
                "CBrrbox",
                "CBalbox",
                "CBacbox",
                "CBarbox",
                "CBraline",
                "CBlcline",
                "CBlrline",
                "CBccline",
                "CBcrline",
                "CBcrline",
                "CBrlline",
                "CBrcline",
                "CBrrline",
                "CBcatalog"
            },
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
                map("]t", todo.jump_next, "Next todo comment", {'n', 'v'})
                map("[t", todo.jump_prev, "Previous todo comment", {'n', 'v'})
                local comments = {"FIX", "WARN", "TODO", "HACK", "NOTE"}
                for _, comment in ipairs(comments) do 
                    map ("[" .. comment:sub(1,1), function() todo.jump_prev({ keywords = {comment} }) end , "Previous " .. comment, {'n', 'v'})
                    map( ']' .. comment:sub(1,1), function() todo.jump_next({ keywords = {comment} }) end , "Next " .. comment, {'n', 'v'})
                end
            end,
        }, -- WARNING: Highlight todo, notes, etc in comments

    }
}
