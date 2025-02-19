local selected_bg = "#3f3f46"
local bg = "#18181b"

return {
    {
        "akinsho/bufferline.nvim",
        event = "VimEnter",
        dependencies = {
            "moll/vim-bbye",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("bufferline").setup {
                options = {
                    mode = "buffers",
                    themable = true,
                    numbers = "none",
                    middle_mouse_command = "Bdelete! %d",
                    path_components = 1,
                    max_name_length = 30,
                    max_prefix_length = 30,
                    tab_size = 21,
                    diagnostics = 'nvim_lsp',
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        return "(" .. count .. ")"
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true
                        }
                    },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    persist_buffer_sort = true,     -- whether or not custom sorted buffers should persist
                    separator_style = { "|", "|" }, -- | "thick" | "thin" | { "any", "any" },
                    enforce_regular_tabs = true,
                    always_show_bufferline = true,
                    show_tab_indicators = false,
                    indicator = { style = 'none' },
                    icon_pinned = "󰐃",
                    minimum_padding = 1,
                    maximum_padding = 3,
                    maximum_length = 15,
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = {'close'}
                    },
                },
                highlights = {
                    fill = { bg = vim.api.nvim_get_hl_by_name('Normal', true).background },
                    buffer_selected = {
                        fg = "#e4e4e7",
                        bg = selected_bg,
                        bold = true,
                        italic = false
                    },
                    close_button = { bg = bg, },
                    close_button_selected = { bg = selected_bg, },
                    background = { bg = bg },
                    modified_selected = { bg = selected_bg },
                    modified = { bg = bg },
                    diagnostic = { bg = bg },
                    diagnostic_selected = { bg = bg },
                },

            }
        end,
    },
    { "tiagovla/scope.nvim", config = true, event = 'vimEnter' },
    {
        'ThePrimeagen/harpoon',
        keys = {
            { "<leader>fa", "<cmd>lua require('harpoon.mark').add_file()<CR>",            desc = "Add file to harpoon" },
            { "<leader>fm", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", desc = "Harpoon menu" },
            { "<leader>fn", "<cmd>lua require('harpoon.ui').nav_next()<CR>",              desc = "Next harpoon" },
            { "<leader>fp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>",              desc = "Previous harpoon" },
            { "<leader>ff", "<cmd>lua require('harpoon.ui').nav_file()<CR>",              desc = "Open harpoon file" },
        }
    }
}
