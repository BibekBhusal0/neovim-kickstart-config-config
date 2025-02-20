local selected_bg = "#3f3f46"
local bg = "#18181b"
local map = require('utils.map')

local saveSesssion = function ()
    require("utils.input")(" Session Name ", function(text) vim.cmd("SessionSave " .. text) end, '', 40)
end
local deleteSessfion = function ()
    require("utils.input")(" Session Name ", function(text) vim.cmd("SessionDelete " .. text) end, '', 40)
end
map("<leader>fS", saveSesssion, "Session Save")
map("<leader>fD", deleteSessfion, "Session Delete")

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
                    show_close_icon = false,
                    persist_buffer_sort = true,     -- whether or not custom sorted buffers should persist
                    separator_style = { "|", "|" }, -- | "thick" | "thin" | { "any", "any" },
                    enforce_regular_tabs = true,
                    always_show_bufferline = true,
                    show_tab_indicators = false,
                    indicator = { style = 'none' },
                    minimum_padding = 1,
                    maximum_padding = 3,
                    maximum_length = 15,
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { 'close' }
                    },
                    custom_areas = {
                        right = function()
                            local result = {}
                            local current_tab = vim.fn.tabpagenr()
                            local tab_count = vim.fn.tabpagenr('$')

                            if tab_count > 1 then
                                for i = 1, tab_count do
                                    local is_active = (i == current_tab)
                                    local left = is_active and "▏" or " "
                                    local right = is_active and "▕" or " "

                                    table.insert(result, {
                                        text = left .. i .. right,
                                        link = is_active and "CurSearch" or "TermCursor",
                                    })
                                end
                            end

                            return result
                        end,
                    }

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
            { "<leader>fa", ": lua require('harpoon.mark').add_file()<CR>",        desc = "Harpoon Add File" },
            { "<leader>fm", ": lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon Menu" },
            { "<leader>fn", ": lua require('harpoon.ui').nav_next()<CR>",          desc = "Harpoon Next" },
            { "<leader>fp", ": lua require('harpoon.ui').nav_prev()<CR>",          desc = "Harpoon Previous" },
            { "<leader>ft", ": lua require('harpoon.mark').toggle_file()<CR>",     desc = "Harpoon Toggle File" },
            { "<leader>fc", ": lua require('harpoon.mark').clear_all()<CR>",       desc = "Harpoon Clear Files" },
        }
    },
    {
        'rmagatti/auto-session',
        cmd = {
            "SessionSave",
            "SessionRestore",
            "SessionDelete",
            "SessionDisableAutoSave",
            "SessionToggleAutoSave",
            "SessionPurgeOrphaned",
            "SessionSearch",
        },
        keys = {
            { "<leader>fs", "<cmd>SessionSave<CR>",           desc = "Session Save" },
            { "<leader>fr", "<cmd>SessionRestore<CR>",        desc = "Session Restore" },
            { "<leader>fR", "<cmd>SessionSearch<CR>",         desc = "Session Search" },
            { "<leader>fd", "<cmd>SessionDelete<CR>",         desc = "Session Delete" },
            { "<leader>fA", "<cmd>SessionToggleAutosave<CR>", desc = "Session TOggle Autosave" },
        },
        config = function()
            require('auto-session').setup {
                auto_save = false,
                auto_restore = false,
                auto_create = false,
                git_branch = true
            }
        end
    },
}
