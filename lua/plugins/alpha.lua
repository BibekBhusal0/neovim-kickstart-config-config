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

    local function button(sc, icon, txt, keybind, hl)
        local leader = "SPC"
        local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

        local opts = {
            position = "center",
            shortcut = sc,
            cursor = 3,
            width = 50,
            align_shortcut = "right",
            hl_shortcut = hl or "Keyword",
            hl = hl or "Added"
        }
        if keybind then
            opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true, nowait = true } }
        end

        local function on_press()
            local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
            vim.api.nvim_feedkeys(key, "t", false)
        end

        return {
            type = "button",
            val = icon .. "  > " .. txt,
            on_press = on_press,
            opts = opts,
        }
    end

    local buttons_divider = {
        type = "text",
        val = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        opts = { position = "center", hl = "Comment" }
    }

    local buttonGroup1 = {
        type = "group",
        val = {
            {
                type = "group",
                val = {
                    button("f", "", "Find file", ":Telescope find_files<CR>"),
                    button("r", "", "Recent Files", ":Telescope oldfiles<CR>"),
                    button("n", "", "New file", ":ene <BAR> startinsert <CR>"),
                    button("t", "󰙅", "File Explorer", ":Neotree toggle position=left <CR>"),
                },
                opts = { spacing = 1 }
            },
            button("g", "󰊢", "Git File Changes", ":Neotree float git_status <CR>"),
        },
    }

    local buttonGroup2 = {
        type = "group",
        val  = {
            button("p", "", "Plugins", ":Lazy<CR>"),
            button("c", "󱙓", "Cheat Sheet", ':lua require("nvcheatsheet").toggle()<CR>'),
            button("s", "", "Settings", ":e $MYVIMRC | :cd %:p:h<CR>"),
            button("q", "󰅙", "Quit", ":qa<CR>", 'DiagnosticError'),
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

    local function getFooter(val)
        return { type = "text", val = val, opts = { position = "center", hl = "Ignore" } }
    end

    local footer = {
        type = "group",
        val = {
            getFooter(prettifyFooterText("", string.format("%d plugins loaded", get_plugin_count()))),
            getFooter(prettifyFooterText("", string.format("Startup Time %d ms", get_lazy_startup_time()))),
            getFooter(prettifyFooterText("", string.format("Today: %s", os.date("%Y-%m-%d")))),
            { type = "padding", val = 1 },
            getFooter({
                [[ There are only two ways to write error free programs,]],
                [[ and the third one works.                             ]],
                [[                                             -Fireship]],
            })
        },
    }

    local content = {
        layout = {
            {
                type = "text",
                val = header,
                opts = { position = "center", hl = "Type" }
            },
            { type = "padding", val = 3 },
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
        require('utils.map')("<leader>a", "<cmd>Alpha<CR>", "Toggle Alpha Dashboard")
    end
}
