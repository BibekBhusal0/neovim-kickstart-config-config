local showCheatSheet = false

local function getCheatSheet()
    local cheat_sheet = require('core.cheatsheet')

    -- Custom section creator with better formatting
    local function create_section(section)
        local content = {
            { type = "text", val = "━━━━━━━━ " .. section.title:upper() .. " ━━━━━━━━", opts = { hl = "Title", position = "center" } },
            { type = "padding", val = 1 },
        }

        for _, cmd in ipairs(section.commands) do
            local parts = vim.split(cmd, "-", { plain = true, trimempty = true })
            local command = string.format("▏%-28s", parts[1] or "")
            local desc = parts[2] or ""
            table.insert(content, {
                type = "text",
                val = command .. " " .. desc,
                opts = { hl = "Comment", position = "left" }
            })
        end
        table.insert(content, { type = "padding", val = 2 })

        return {
            type = "group",
            val = content,
            opts = { spacing = 0 }
        }
    end

    local gr = {
        { type = "text",     val = "Press <leader>ct to go home", opts = { position = "center" } },
        { type = "padding",  val = 3 },
    }
    for _, grid_block in ipairs(cheat_sheet) do
        for _, column in ipairs(grid_block) do
            local col_content = {}
            for _, section in ipairs(column) do
                table.insert(col_content, create_section(section))
            end
            table.insert(gr, {
                type = "group",
                val = col_content,
                opts = {
                    spacing = 2,
                    margin = 4,
                }
            })
        end
    end

    return gr
end


local maxChar = 25
local function prettifyFooterText(icon ,text)
    local str = icon .. "   " .. text
    if #str > maxChar then
        return str:sub(1, maxChar)
    else
        return str .. string.rep(" ", maxChar - #str)
    end
end


local function render()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    local function get_plugin_count()
        local plugins = require('lazy').plugins()
        return #plugins
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
    local header_cheat_sheet = {
        [[   ______  __                           __           ______  __                           __]],
        [[  /      \|  \                         |  \         /      \|  \                         |  \]],
        [[ |  ▓▓▓▓▓▓\ ▓▓____   ______   ______  _| ▓▓_       |  ▓▓▓▓▓▓\ ▓▓____   ______   ______  _| ▓▓_]],
        [[ | ▓▓   \▓▓ ▓▓    \ /      \ |      \|   ▓▓ \      | ▓▓___\▓▓ ▓▓    \ /      \ /      \|   ▓▓ \]],
        [[ | ▓▓     | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\ \▓▓▓▓▓▓\\▓▓▓▓▓▓       \▓▓    \| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓▓▓▓▓]],
        [[ | ▓▓   __| ▓▓  | ▓▓ ▓▓    ▓▓/      ▓▓ | ▓▓ __      _\▓▓▓▓▓▓\ ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓    ▓▓ | ▓▓ __]],
        [[ | ▓▓__/  \ ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ | ▓▓|  \    |  \__| ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓▓ | ▓▓|  \]],
        [[  \▓▓    ▓▓ ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓  \▓▓  ▓▓     \▓▓    ▓▓ ▓▓  | ▓▓\▓▓     \\▓▓     \  \▓▓  ▓▓]],
        [[   \▓▓▓▓▓▓ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓   \▓▓▓▓       \▓▓▓▓▓▓ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓   \▓▓▓▓]],
    }



    -- https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1309233
    -- Set menu
    local buttons_divider = { type = "text", val = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', opts = { position = "center" } }
    local buttons = {
        dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("a", "  > Sessions", '<cmd>SessionSearch<CR>'),
        buttons_divider,
        dashboard.button("p", "󰐱  > Plugins", ":Lazy<CR>"),
        dashboard.button("c", "  > Cheat sheet", ':AlphaShowCheatSheet<CR>'),
        dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h<CR>"),
        dashboard.button("q", "󰅙  > Quit", ":qa<CR>"),
    }


    local main = buttons
    if showCheatSheet then
        main = getCheatSheet()
        header = header_cheat_sheet
    end

    local footer = {
        [[ There are only two ways to write error free programs,]],
        [[ and the third one works.                             ]],
        [[                                             -Fireship]],
    }

    dashboard.config.layout = {
        { type = "padding", val = 1 },
        {
            type = "text",
            val = header,
            opts = { position = "center", hl = "Title" }
        },
        { type = "padding", val = 3 },
        {
            type = "group",
            val = main,
            opts = { position = "center" }
        },
        { type = "padding", val = 3 },
        {
            type = "text",
            val = prettifyFooterText('', string.format('%s plugins loaded', get_plugin_count())),
            opts = { position = "center", hl = "AlphaFooter" }
        },
        {
            type = "text",
            val = prettifyFooterText('', string.format('Today: %s', os.date("%Y-%m-%d"))),
            opts = { position = "center", hl = "AlphaFooter" }
        },
        { type = "padding", val = 1 },
        {
            type = "text",
            val = footer,
            opts = { position = "center", hl = "AlphaFooter" }
        },
    }

    alpha.setup(dashboard.config)
    if vim.bo.filetype == 'alpha' then
        vim.cmd('AlphaRedraw')
    else
        vim.cmd('Alpha')
    end
end

local function toggleCheatSheet()
    showCheatSheet = not showCheatSheet
    render()
end

local function showCS()
    showCheatSheet = true
    render()
end

return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        render()

        vim.api.nvim_create_user_command('AlphaToggleCheatSheet', toggleCheatSheet, { force = true })
        vim.api.nvim_create_user_command('AlphaShowCheatSheet', showCS, { force = true })

        vim.keymap.set('n', '<leader>a', '<cmd>Alpha<CR>', { noremap = true, silent = true, desc = "Alpha Dashboard" })
        vim.keymap.set('n', '<leader>ch', '<cmd>AlphaShowCheatSheet<CR>',
            { noremap = true, silent = true, desc = "Show Cheat Sheet" })
        vim.keymap.set('n', '<leader>ct', '<cmd>AlphaToggleCheatSheet<CR>',
            { noremap = true, silent = true, desc = "Toggle Cheat Sheet" })
    end
}
