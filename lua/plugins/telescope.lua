local searchInCurrentBuffer = function()
    require "telescope.builtin".current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    })
end

local spellSuggestion = function()
    require "telescope.builtin".spell_suggest(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
        default_index= 1,
        initial_mode = 'normal'
    })
end

local searchInOpenFiles = function()
    require "telescope.builtin".live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    }
end

map = require 'utils.map'
map("<leader>sh", ':Telescope help_tags<CR>', "Search Help")
map("<leader>sk", ':Telescope keymaps<CR>', "Search Keymaps")
map("<leader>sf", ':Telescope find_files<CR>', "Search Files")
map("<leader>ss", ':Telescope builtin<CR>', "Search Telescope")
map("<leader>sW", ':Telescope grep_string<CR>', "Search current Word")
map("<leader>sd", ':Telescope diagnostics<CR>', "Search Diagnostics")
map("<leader>sr", ':Telescope resume<CR>', "Search Resume")
map("<leader>sC", ':Telescope commands<CR>', "Search Commands")
map("<leader>s.", ':Telescope oldfiles<CR>', "Search recent Files")
map("<leader>sB", ':Telescope buffers<CR>', "Search buffers in current tab")
map("<leader>sw", ':Telescope live_grep<CR>', "Search by Grep")
map("<leader>sgb", ':Telescope git_branches<CR>', "Search Git Branches")
map("<leader>sgc", ':Telescope git_commits<CR>', "Search Git Commits")
map("<leader>sgC", ':Telescope git_bcommits<CR>', "Search Git Bcommits")
map("<leader>sgs", ':Telescope git_stash<CR>', "Search Git Stash")
map("<leader>sgf", ':Telescope git_files<CR>', "Search Git Files")
map("<leader>sb", ':Telescope scope buffers<CR>', "Seach All Buffers ")
map("<leader>sh", ":Telescope harpoon marks<CR>", "Search Harpoon Marks")
map("<leader>/", searchInCurrentBuffer, "Search in current buffer")
map("<leader>s/", searchInOpenFiles, "Search in Open Files")
map( "<leader>i", spellSuggestion, "Spell suggestion")
map("<leader>sz", spellSuggestion, "Spell suggestion")

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope.actions").move_selection_previous, -- move to prev result
                            ["<C-j>"] = require("telescope.actions").move_selection_next,     -- move to next result
                            ["<C-l>"] = require("telescope.actions").select_default,          -- open file
                        },
                    },
                },
            }
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
        end,
    },
    {
        'debugloop/telescope-undo.nvim', 
        keys = {{"<leader>u" , ":Telescope undo<cr>" , desc = "Undo Tree"}}, 
        cmd = {"Telescope undo"},
        config = function()
            require("telescope").load_extension("undo")
        end
    },
    {
        "zongben/proot.nvim",
        opts = {},
        keys = {
            {"<Leader>sp", ":Proot<Cr>", desc = "Search Directories"}
        },
        cmd = {"Proot"}
    },
    -- {
    --     'ziontee113/icon-picker.nvim',
    --     opts = {} ,
    --     keys = {
    --         { "<leader>si", "<cmd>PickIcons<cr>", desc = "Icon Picker" },
    --         { "<leader>sI", "<cmd>PickIconsYank<cr>", desc = "Icon Picker Yank" },
    --         { "<leader>se", "<cmd>PickEmoji<cr>", desc = "Icon Picker Emoji" },
    --         { "<leader>sE", "<cmd>PickEmojiYank emoji<cr>", desc = "Icon Picker Emoji Yank" },
    --     },
    -- }, -- icon picker with telescope 
}
