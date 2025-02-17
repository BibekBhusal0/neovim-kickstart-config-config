return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
        local mode = {
            "mode",
            fmt = function(str)
                return " " .. str
                -- return " " .. str:sub(1, 1) -- displays only the first character of the mode
            end,
        }

        local filename = {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
        }

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 100
        end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            update_in_insert = false,
            always_visible = false,
            cond = hide_in_width,
        }

        local diff = {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            cond = hide_in_width,
        }

        local codeium_status = {
            function()
                local symbols = {
                    status = {
                        [0] = "󰚩 ", -- Enabled
                        [1] = "󱚧 ", -- Disabled Globally
                        [2] = "󱙻 ", -- Disabled for Buffer
                        [3] = "󱙺 ", -- Disabled for Buffer filetype
                        [4] = "󱙺 ", -- Disabled for Buffer with enabled function
                        [5] = "󱚠 ", -- Disabled for Buffer encoding
                    },
                    server_status = {
                        [0] = "󰣺 ", -- Connected
                        [1] = "󰣻 ", -- Connecting
                        [2] = "󰣽 ", -- Disconnected
                    },
                }
                local status, serverStatus = require("neocodeium").get_status()
                -- print(symbols.status[status], symbols.server_status[serverStatus])

                -- local icon = "󰘦 "
                -- return icon
                return symbols.status[status] .. symbols.server_status[serverStatus]
                -- return "disabled"
            end,
            cond = hide_in_width,
        }


        require("lualine").setup {
            options = {
                icons_enabled = true,
                theme = "onedark_dark",
                --        
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                disabled_filetypes = { "alpha", "neo-tree" },
                always_divide_middle = true,
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { "branch" },
                lualine_c = { filename },
                lualine_x = { diagnostics, diff, { "filetype", cond = hide_in_width } },
                lualine_y = { "location", codeium_status },
                lualine_z = { "progress" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { { "location", padding = 0 } },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { "fugitive" },
        }
    end,
}
