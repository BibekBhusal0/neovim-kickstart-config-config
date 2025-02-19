local searchInCurrentBuffer = function()
    require "telescope.builtin".current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
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
map("<leader>s.", ':Telescope oldfiles<CR>', "Search recent Files")
map("<leader><leader>", ':Telescope buffers<CR>', "Search buffers")
map("<leader>sw", ':Telescope live_grep<CR>', "Search by Grep")
map("<leader>sgb", ':Telescope git_branches<CR>', "Search Git Branches")
map("<leader>sgc", ':Telescope git_commits<CR>', "Search Git Commits")
map("<leader>sgC", ':Telescope git_bcommits<CR>', "Search Git Bcommits")
map("<leader>sgs", ':Telescope git_stash<CR>', "Search Git Stash")
map("<leader>sgf", ':Telescope git_files<CR>', "Search Git Files")
map("<leader>sb", ':Telescope scope buffers<CR>', "Seach Buffers in current tab")
map("<leader>sh", ":Telescope harpoon marks<CR>", "Search Harpoon Marks")
map("<leader>/", searchInCurrentBuffer, "Search Fuzzily search in current buffer")
map("<leader>s/", searchInOpenFiles, "Search [/] in Open Files")

return {
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
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
                require('scope'),
                require('harpoon')
            },
        }
    end,
}
