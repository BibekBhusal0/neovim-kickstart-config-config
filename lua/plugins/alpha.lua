local maxChar = 27
local function prettifyFooterText(icon, text)
    local str = icon .. "   " .. text
    if #str > maxChar then
        return str:sub(1, maxChar)
    else
        return str .. string.rep(" ", maxChar - #str)
    end
end


local function render()
    local alpha = require "alpha"
    local dashboard = require "alpha.themes.dashboard"

    local function get_plugin_count()
        local stats = require("lazy").stats()
        return stats.loaded
    end

    local function get_lazy_startup_time()
        local success, stats = pcall(function()
            return require("lazy").stats()
        end)

        if success and stats.times.LazyDone and stats.times.LazyStart then
            return stats.times.LazyDone - stats.times.LazyStart
        else
            return 0
        end
    end

    local header = {
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    }

    local buttons_divider = {
        type = "text",
        val = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        opts = { position = "center" }
    }

    local buttonGroup1 = {
        type = "group",
        val = {
            {
                type = "group",
                val = {
                    dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
                    dashboard.button("r", "  > Recent Files", ":Telescope oldfiles<CR>"),
                    dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
                    dashboard.button("t", "  > File Explorer", ":Neotree toggle position=left <CR>"),
                },
                opts = { spacing = 1 }
            },
            dashboard.button("g", "󰊢  > Git File Changes", ":Neotree float git_status <CR>"),
        },
    }

    local buttonGroup2 = {
        type = "group",
        val  = {
            dashboard.button("p", "  > Plugins", ":Lazy<CR>"),
            dashboard.button("m", "  > Mason (LSP,  linter, formatter)", ":Mason<CR>"),
            dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h<CR>"),
            dashboard.button("q", "󰅙  > Quit", ":qa<CR>"),
        },
        opts = { spacing = 1 }
    }


    local buttons = {
        type = "group",
        val = {
            buttonGroup1,
            buttons_divider,
            buttonGroup2,
        },
    }

    local footer = {
        type = "group",
        val = {
            {
                type = "text",
                val = prettifyFooterText("", string.format("%d plugins loaded", get_plugin_count())),
                opts = { position = "center", hl = "Number" }
            },
            {
                type = "text",
                val = prettifyFooterText("", string.format("Startup Time %d ms", get_lazy_startup_time())),
                opts = { position = "center", hl = "Number" }
            },
            {
                type = "text",
                val = prettifyFooterText("", string.format("Today: %s", os.date("%Y-%m-%d"))),
                opts = { position = "center", hl = "Number" }
            },
            { type = "padding", val = 1 },
            {
                type = "text",
                val = {
                    [[ There are only two ways to write error free programs,]],
                    [[ and the third one works.                             ]],
                    [[                                             -Fireship]],
                },
                opts = { position = "center", hl = "Number" }
            },
        },
    }

    local content = {
        layout = {
            {
                type = "text",
                val = header,
                opts = { position = "center", hl = "Type" }
            },
            { type = "padding", val = 2 },
            buttons,
            { type = "padding", val = 1 },
            footer
        },
        opts = {}
    }

    alpha.setup(content)
end


vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.defer_fn(function()
            if vim.bo.filetype == "alpha" then
                render()
                vim.cmd("AlphaRedraw")
            end
        end, 5)
    end,
})


return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    lazy = false,
    priority = 1001,

    config = function()
        render()
        vim.keymap.set("n", "<leader>a", "<cmd>Alpha<CR>", { noremap = true, silent = true, desc = "Alpha Dashboard" })
    end
}
