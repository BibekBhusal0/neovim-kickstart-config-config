local wrap_keys = require 'utils.wrap_keys'
local selected_bg = '#095028'
local bg = '#18181b'
local tab_selected = '#74dfa2'
local tab = '#052814'
local map = require 'utils.map'

-- Resize with arrows
map('<Up>', ':resize -2<CR>', 'Resize window up')
map('<Down>', ':resize +2<CR>', 'Resize window down')
map('<Left>', ':vertical resize -2<CR>', 'Resize window left')
map('<Right>', ':vertical resize +2<CR>', 'Resize window right')

-- Buffers
map('<leader>bb', ':enew<CR>', 'Buffer New')

-- Window management
map('<leader>v', ':vsplit<CR>', 'Split window vertically')
map('<leader>h', ':split<CR>', 'Split window horizontally')
map('<leader>V', ':vsplit | ter<CR>', 'Split window vertically')
map('<leader>H', ':split | ter<CR>', 'Split window horizontally')
map('<leader>br', ':e!<CR>', 'Buffer Reset')

-- Navigate between splits
map('<C-k>', ':wincmd k<CR>', 'Window up')
map('<C-j>', ':wincmd j<CR>', 'Window down')
map('<C-h>', ':wincmd h<CR>', 'Window left')
map('<C-l>', ':wincmd l<CR>', 'Window right')
map('<C-p>', ':wincmd p<CR>', 'Window Floating')

-- Tabs
map('<leader>to', ':tabnew<CR>', 'Tab new')
map('<leader>tO', ':tabonly<CR>', 'Tab Close other')
map('<leader>tx', ':tabclose<CR>', 'Tab close')
map('<leader>tn', ':tabn<CR>', 'Tab next')
map('<leader>tp', ':tabp<CR>', 'Tab Previous')

local function gotoTab()
  require 'utils.input'(' Tab ', function(text)
    vim.cmd('tabn ' .. text)
  end, '', 9, '  ')
end
map('<leader>tg', gotoTab, 'Tab goto')

return {
  {
    'akinsho/bufferline.nvim',
    event = 'VimEnter',
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          themable = true,
          close_command = 'Bdelete! %d',
          close_icon = ' 󰅙',
          middle_mouse_command = 'Bdelete! %d',
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count)
            return '(' .. count .. ')'
          end,
          offsets = {
            {
              filetype = 'codecompanion',
              text = 'Code Companion',
              text_aligh = 'center',
              separator = true,
            },
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              text_align = 'left',
              separator = true,
            },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
          separator_style = { '', '' }, -- | "thick" | "thin" | { "any", "any" },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          show_tab_indicators = true,
          indicator = { style = 'icon', icon = '' },
          minimum_padding = 1,
          maximum_padding = 3,
          maximum_length = 15,
          sort_by = 'insert_at_end',
          hover = { enabled = true, delay = 200, reveal = { 'close' } },
        },
        highlights = {
          buffer_selected = {
            fg = '#e4e4e7',
            bg = selected_bg,
            bold = true,
            italic = false,
          },
          close_button = { bg = bg },
          close_button_selected = { bg = selected_bg },
          background = { bg = bg },
          modified_selected = { bg = selected_bg },
          modified = { bg = bg },
          diagnostic = { bg = bg },
          diagnostic_selected = { bg = bg },
          tab_close = { fg = '#f31260' },
        },
      }
      vim.api.nvim_set_hl(0, 'BufferLineTabSelected', { bg = tab_selected, fg = tab })
      vim.api.nvim_set_hl(0, 'BufferLineTab', { bg = tab, fg = tab_selected })
      map('<Tab>', ':BufferLineCycleNext<CR>', 'Buffer Cycle Next')
      map('<S-Tab>', ':BufferLineCyclePrev<CR>', 'Buffer Cycle Previous')
      map('<leader>bp', ':BufferLineTogglePin<CR>', 'Buffer Toggle Pin')
      map('<leader>bc', ':BufferLinePick<CR>', 'Buffer Pick')
      map('<leader>bk', ':BufferLineMoveNext<CR>', 'Buffer Move Next')
      map('<leader>bj', ':BufferLineMovePrev<CR>', 'Buffer Move Prev')
      map('<leader>bo', ':BufferLineCloseOthers<CR>', 'Buffer Close others')
      map('<leader>bH', ':BufferLineCloseLeft<CR>', 'Buffer Close Prev')
      map('<leader>bL', ':BufferLineCloseRight<CR>', 'Buffer Close Next')
      map('<leader>bse', ':BufferLineSortByExtension<CR>', 'Buffer Sort By Extension')
      map('<leader>bsr', ':BufferLineSortByRelativeDirectory<CR>', 'Buffer Sort By Relative Directory')
    end,
  }, -- show open buffer  and tab

  {
    'moll/vim-bbye',
    cmd = { 'Bdelete', 'Bwipeout' },
    keys = wrap_keys {
      { '<leader>xb', ':Bdelete<CR>', desc = 'Close Buffer' },
      { '<leader>xB', ':Bdelete!<CR>', desc = 'Close Buffer Force' },
      { '<leader>bx', ':Bdelete<CR>', desc = 'Buffer Close' },
    },
  }, -- close buffer without closing tab

  {
    'tiagovla/scope.nvim',
    event = { 'VimEnter' },
    config = function()
      require('scope').setup()
      map('<leader>bm', function()
        require 'utils.input'('Tab Idx', function(text)
          vim.cmd('ScopeMoveBuf' .. text)
        end, '', 9, '  ')
      end, 'Move Buffer')
    end,
  }, -- only show buffer from current tag

  {
    'stevearc/resession.nvim',
    keys = wrap_keys {
      { '<leader>Ss', ':lua require("resession").save()<CR>', desc = 'Session Save' },
      { '<leader>SS', ':lua require("resession").save_tab()<CR>', desc = 'Session Save Tab' },
      { '<leader>Sl', ':lua require("resession").load()<CR>', desc = 'Session Load' },
      { '<leader>Sd', ':lua require("resession").delete()<CR>', desc = 'Session Delete' },
    },
    opts = {
      buf_filter = function(bufnr)
        local buftype = vim.bo.buftype
        if buftype == 'help' then
          return true
        end
        if buftype ~= '' and buftype ~= 'acwrite' then
          return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == '' then
          return false
        end
        return true
      end,
      extensions = { scope = {} },
    },
  }, -- session management

  {
    'ThePrimeagen/harpoon',
    keys = wrap_keys {
      { '<leader>fa', ":lua require('harpoon.mark').add_file()<CR>", desc = 'Harpoon Add File' },
      { '<leader>fc', ":lua require('harpoon.mark').clear_all()<CR>", desc = 'Harpoon Clear Files' },
      { '<leader>fj', ":lua require('harpoon.ui').nav_prev()<CR>", desc = 'Harpoon Previous' },
      { '<leader>fk', ":lua require('harpoon.ui').nav_next()<CR>", desc = 'Harpoon Next' },
      { '<leader>fm', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = 'Harpoon Menu' },
      { '<leader>fn', ":lua require('harpoon.ui').nav_next()<CR>", desc = 'Harpoon Next' },
      { '<leader>fp', ":lua require('harpoon.ui').nav_prev()<CR>", desc = 'Harpoon Previous' },
      { '<leader>ft', ":lua require('harpoon.mark').toggle_file()<CR>", desc = 'Harpoon Toggle File' },
    },
  }, -- pinning files and quickly moving between them

  {
    'BibekBhusal0/bufstack.nvim',
    event = { 'BufNewFile', 'BufReadPost' },
    config = function()
      require('bufstack').setup { max_tracked = 400 }
      map('gl', ':BufStackNext<CR>', 'Buffer Next Recent')
      map('gh', ':BufStackPrev<CR>', 'Buffer Prevevious Recent')
      map('<leader>bu', ':BufStackList<CR>', 'Buffer Open List')
      map('<leader>bh', ':BufClosedList<CR>', 'Buffer Closed List')
      map('<leader>ba', ':BufReopen<CR>', 'Buffer Repoen')
    end,
  }, -- Reopen closed buffer and cycle through recently closed buffer

  {
    'anuvyklack/windows.nvim',
    dependencies = { 'anuvyklack/middleclass', 'anuvyklack/animation.nvim' },
    keys = wrap_keys {
      { '<leader>w=', ':WindowsEqualize<CR>', 'Window Equalize' },
      { '<leader>wf', ':WindowsMaximize<CR>', 'Window Maximize' },
      { '<leader>wh', ':WindowsMaximizeHorizontally<CR>', 'Window Maximize Horizontally' },
      { '<leader>wt', ':WindowsToggleAutowidth<CR>', 'Window Toggle Autowidth' },
      { '<leader>wv', ':WindowsMaximizeVertically<CR>', 'Window Maximize Vertically' },
    }, -- autowidth is disabled so this is not needed
    config = function()
      vim.o.winwidth = 20
      vim.o.winminwidth = 15
      vim.o.equalalways = false
      require('windows').setup { autowidth = { enable = false } }
    end,
  }, -- split window autosize with better animations

  {
    'MisanthropicBit/winmove.nvim',
    keys = wrap_keys {
      { '<leader>ws', ":lua require'winmove'.start_mode('swap')<CR>", desc = 'Window Swap mode' },
      { '<leader>wm', ":lua require'winmove'.start_mode('move')<CR>", desc = 'Window Move mode' },
    },
  }, -- Easy move and swap split windows

  {
    'jyscao/ventana.nvim',
    cmd = { 'VentanaTranspose', 'VentanaShift', 'VentanaShiftMaintailLinear' },
    keys = wrap_keys {
      { '<leader>wr', ':VentanaTranspose<CR>', desc = 'Window Rotate(transpose)' },
      { '<leader>ww', ':VentanaShift<CR>', desc = 'Window Shift' },
    },
  }, -- easy change layout of split window

  {
    's1n7ax/nvim-window-picker',
    main = 'window-picker',
    lazy = true,
    keys = wrap_keys {
      { '<leader>wp', ":lua local w = require'window-picker'.pick_window() vim.api.nvim_set_current_win(w)<CR>", desc = 'Window pick' },
    },
    opts = { hint = 'floating-big-letter' },
  }, -- picking window
}
