local map = require("utils.map")
return {
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        },
        keys  = {{"<leader>lm", ":lua require('nvim-navbuddy').open()<CR>", desc = "Open Navbuddy" }} ,
        config = function () 
            local navbuddy = require("nvim-navbuddy")
            local icons = {}
            for k, v in pairs(require('utils.icons')) do 
                icons[k] =  v .. ' '
            end

            navbuddy.setup({
                lsp = { auto_attach = true },
                icons = icons,
            })
        end
    }, -- Better navigation with LSP
    {
        'ziontee113/syntax-tree-surfer',
        event = { "BufReadPre", "BufNewFile" },
        config = function () 
            local sts = require('syntax-tree-surfer')
            sts.setup({
                icon_dictionary = {
                    ["if_statement"] = "󰵉",
                    ["else_clause"] = "󱞽",
                    ["else_statement"] = "󱞽",
                    ["elseif_statement"] = "󰵕",
                    ["for_statement"] = "󰑓ﭜ",
                    ["while_statement"] = "󰑓",
                    ["switch_statement"] = "",
                    ["function"] = "󰡱",
                    ["function_definition"] = "󰊕",
                    ["variable_declaration"] = "󰫧",
                },
            })
            map("vx", ":STSSelectMasterNode<cr>", "Select Master Node")
            map("vn", ":STSSelectCurrentNode<cr>", "Select Current Node")
            local jumps = {
                f = {"function", "arrrow_function", "function_definition"},
                i = {"if_statemet", "else_statement", "else_clause", "switch_statement", "if_clause"} , 
                l = {"for_statement", 'while_statement' },
            }

            for k, v in pairs(jumps) do 
                map("]" .. k, function() sts.filtered_jump(v, true) end, "Jump to next " .. k, {'n', 'v'})
                map("[" .. k, function() sts.filtered_jump(v, false) end, "Jump to previous " .. k, {'n', 'v'})
            end
            map("<leader>j", function() sts.targeted_jump({
                "function",
                "if_statement",
                "else_clause",
                "else_statement",
                "elseif_statement",
                "for_statement",
                "while_statement",
                "switch_statement",
            }) end, "Jump to next node")
        end
    }, --- better navigation with treesitter 
}
