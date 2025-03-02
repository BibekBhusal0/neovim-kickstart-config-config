local selected_bg = '#095028'
local bg = '#18181b'
local tab_selected = '#f31260'
local tab = '#310413'

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
  end, '', 5)
end
map('<leader>tg', gotoTab, 'Tab goto')

-- leader t 0-9 to move between tabs
for i = 1, 9 do
  map('<leader>t' .. i, ':tabn ' .. i .. '<CR>', 'Tab ' .. i)
end

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
          middle_mouse_command = 'Bdelete! %d',
          right_mouse_command = false,
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return '(' .. count .. ')'
          end,
          offsets = {
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
          show_close_icon = false,
          persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
          separator_style = { '', '' }, -- | "thick" | "thin" | { "any", "any" },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          show_tab_indicators = true,
          indicator = { style = 'icon', icon = '▕' },
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
          tab = { bg = tab },
          tab_selected = { bg = tab_selected },
        },
      }

      map('<Tab>', ':BufferLineCycleNext<CR>', 'Buffer Cycle Next')
      map('<S-Tab>', ':BufferLineCyclePrev<CR>', 'Buffer Cycle Previous')
      map('<leader>bp', ':BufferLineTogglePin<CR>', 'Buffer Toggle Pin')
      map('<leader>bc', ':BufferLinePick<CR>', 'Buffer Pick')
      map('<leader>bk', ':BufferLineMoveNext<CR>', 'Buffer Move Next')
      map('<leader>bj', ':BufferLineMovePrev<CR>', 'Buffer Move Prev')
      map('<leader>bo', ':BufferLineCloseOthers<CR>', 'Buffer Close others')
      map('<leader>bh', ':BufferLineCyclePrev<CR>', 'Buffer Cycle Prev')
      map('<leader>bl', ':BufferLineCycleNext<CR>', 'Buffer Cycle Next')
      map('<leader>bH', ':BufferLineCloseLeft<CR>', 'Buffer Close Prev')
      map('<leader>bL', ':BufferLineCloseRight<CR>', 'Buffer Close Next')
      map('<leader>bse', ':BufferLineSortByExtension<CR>', 'Buffer Sort By Extension')
      map('<leader>bsr', ':BufferLineSortByRelativeDirectory<CR>', 'Buffer Sort By Relative Directory')

      for i = 1, 9 do
        map('<leader>b' .. i, ':BufferLineGoToBuffer ' .. i .. '<CR>', 'Buffer Go to ' .. i)
      end
    end,
  },

  {
    'moll/vim-bbye',
    cmd = { 'Bdelete', 'Bwipeout' },
    keys = {
      { '<leader>xb', ':Bdelete<CR>', desc = 'Close Buffer' },
      { '<leader>xB', ':Bdelete!<CR>', desc = 'Close Buffer Force' },
      { '<leader>bx', ':Bdelete<CR>', desc = 'Buffer Close' },
    },
  },

  {
    'tiagovla/scope.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('scope').setup()
      map('<leader>bm', function()
        require 'utils.input'('Tab Idx', function(text)
          vim.cmd('ScopeMoveBuf' .. text)
        end, '', 5)
      end, 'Move Buffer')
    end,
  },

  {
    'stevearc/resession.nvim',
    keys = {
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
  },

  {
    'ThePrimeagen/harpoon',
    keys = {
      { '<leader>fa', ": lua require('harpoon.mark').add_file()<CR>", desc = 'Harpoon Add File' },
      { '<leader>fm', ": lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = 'Harpoon Menu' },
      { '<leader>fn', ": lua require('harpoon.ui').nav_next()<CR>", desc = 'Harpoon Next' },
      { '<leader>fp', ": lua require('harpoon.ui').nav_prev()<CR>", desc = 'Harpoon Previous' },
      { '<leader>ft', ": lua require('harpoon.mark').toggle_file()<CR>", desc = 'Harpoon Toggle File' },
      { '<leader>fc', ": lua require('harpoon.mark').clear_all()<CR>", desc = 'Harpoon Clear Files' },
    },
  },

  {
    'anuvyklack/windows.nvim',
    event = { 'BufNewFile', 'BufReadPost' },
    dependencies = { 'anuvyklack/middleclass', 'anuvyklack/animation.nvim' },
    config = function()
      vim.o.winwidth = 20
      vim.o.winminwidth = 15
      vim.o.equalalways = false
      require('windows').setup()
      map('<leader>wm', ':WindowsMaximize<CR>', 'Window Maximize')
      map('<leader>wv', ':WindowsMaximizeVertically<CR>', 'Window Maximize Vertically')
      map('<leader>wh', ':WindowsMaximizeHorizontally<CR>', 'Window Maximize Horizontally')
      map('<leader>w=', ':WindowsEqualize<CR>', 'Window Equalize')
      map('<leader>wt', ':WindowsToggleAutowidth<CR>', 'Window Toggle Autowidth')
    end,
  },
}
