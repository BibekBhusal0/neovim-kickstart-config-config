local map = vim.keymap.set

map("n", "<leader>sh", ':Telescope help_tags<CR>', { desc = "Search Help" })
map("n", "<leader>sk", ':Telescope keymaps<CR>', { desc = "Search Keymaps" })
map("n", "<leader>sf", ':Telescope find_files<CR>', { desc = "Search Files" })
map("n", "<leader>ss", ':Telescope builtin<CR>', { desc = "Search Telescope" })
map("n", "<leader>sW", ':Telescope grep_string<CR>', { desc = "Search current Word" })
map("n", "<leader>sd", ':Telescope diagnostics<CR>', { desc = "Search Diagnostics" })
map("n", "<leader>sr", ':Telescope resume<CR>', { desc = "Search Resume" })
map("n", "<leader>s.", ':Telescope oldfiles<CR>', { desc = "Search recent Files" })
map("n", "<leader><leader>", ':Telescope buffers<CR>', { desc = "Search buffers" })
map("n", "<leader>sw", ':Telescope live_grep<CR>', { desc = "Search by Grep" })
map("n", "<leader>sgb", ':Telescope git_branches<CR>', { desc = "Search Git Branches" })
map("n", "<leader>sgc", ':Telescope git_commits<CR>', { desc = "Search Git Commits" })
map("n", "<leader>sgC", ':Telescope git_bcommits<CR>', { desc = "Search Git Bcommits" })
map("n", "<leader>sgs", ':Telescope git_stash<CR>', { desc = "Search Git Stash" })
map("n", "<leader>sgf", ':Telescope git_files<CR>', { desc = "Search Git Files" })

map("n", "<leader>/", function()
    require "telescope.builtin".current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = "[/] Fuzzily search in current buffer" })

map("n", "<leader>s/", function()
    require "telescope.builtin".live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    }
end, { desc = "[S]earch [/] in Open Files" })

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
            },
        }
    end,
}
