return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    local function get_plugin_count()
        local plugins = require('lazy').plugins()
        return #plugins
    end


    dashboard.section.header.val = {
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
    }

    -- https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1309233
    -- Set menu
    dashboard.section.buttons.val = {
        dashboard.button( "f", "  > Find file", ":Telescope find_files<CR>"),
        dashboard.button( "n", "  > New file" , ":ene <BAR> startinsert <CR>"),
        dashboard.button( "r", "  > Recent Files"   , ":Telescope oldfiles<CR>"),
        dashboard.button( "a", "  > Sessions", '<cmd>SessionSearch<CR>'),
        dashboard.button( "c", "  > CheatSheet", ":NvCheatsheet<CR>"),
        dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h<CR>"),
        dashboard.button( "p", "󰐱  > Plugins", ":Lazy<CR>"),
        dashboard.button( "g", "󰘺  > Games", "<cmd>Playtime<CR>"),
        dashboard.button( "q", "󰅙  > Quit", ":qa<CR>"),
    }

    dashboard.section.footer.val = {
        [[                                                      ]],
        [[                                                      ]],
        string.format('  %s plugins loaded', get_plugin_count()),
        [[                                                      ]],
        [[ There are only two ways to write error free programs,]],
        [[ and the third one works.                             ]],
        [[                                             -Fireship]],
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[
        autocmd FileType alpha setlocal nofoldenable
    ]])
    end,
    vim.keymap.set('n', '<leader>a' , '<cmd>Alpha<CR>', { noremap = true, silent = true , desc = "Alpha Dashboard" })
}
