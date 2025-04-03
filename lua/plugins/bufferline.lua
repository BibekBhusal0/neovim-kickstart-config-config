local selected_bg = '#095028'
local bg = '#18181b'
local tab_selected = '#74dfa2'
local tab = '#052814'
local map = require 'utils.map'

return {
  'akinsho/bufferline.nvim',
  event = 'VimEnter',
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
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
        close_button = { bg = bg, fg = '#f31260' },
        close_button_selected = { bg = selected_bg, fg = '#f31260' },
        background = { bg = bg },
        modified_selected = { bg = selected_bg },
        modified = { bg = bg },
        diagnostic = { bg = bg },
        diagnostic_selected = { bg = bg },
        tab_close = { fg = '#f31260' },
      },
    }
    vim.api.nvim_set_hl(0, 'BufferLineTabSelected', { bg = tab_selected, fg = tab })
    local function close_all_saved_buffers()
      for _, e in ipairs(bufferline.get_elements().elements) do
        vim.schedule(function()
          if vim.bo[e.id].modified == false then
            vim.cmd('bd ' .. e.id)
          end
        end)
      end
    end
    local function renameTab()
      require 'utils.input'('Tab name', function(text)
        bufferline.rename_tab { text }
      end, '', 15, '󰓩 ')
    end
    vim.api.nvim_set_hl(0, 'BufferLineTab', { bg = tab, fg = tab_selected })
    map('<Tab>', ':BufferLineCycleNext<CR>', 'Buffer Cycle Next')
    map('<S-Tab>', ':BufferLineCyclePrev<CR>', 'Buffer Cycle Previous')
    map('<leader>bp', ':BufferLineTogglePin<CR>', 'Buffer Toggle Pin')
    map('<leader>bc', ':BufferLinePick<CR>', 'Buffer Pick')
    map('<leader>bC', bufferline.close_with_pick, 'Buffer Pick and close')
    map('<leader>bk', ':BufferLineMoveNext<CR>', 'Buffer Move Next')
    map('<leader>bj', ':BufferLineMovePrev<CR>', 'Buffer Move Prev')
    map('<leader>bo', ':BufferLineCloseOthers<CR>', 'Buffer Close others')
    map('<leader>bH', ':BufferLineCloseLeft<CR>', 'Buffer Close Prev')
    map('<leader>bL', ':BufferLineCloseRight<CR>', 'Buffer Close Next')
    map('<leader>bse', ':BufferLineSortByExtension<CR>', 'Buffer Sort By Extension')
    map('<leader>bsr', ':BufferLineSortByRelativeDirectory<CR>', 'Buffer Sort By Relative Directory')
    map('<leader>bX', close_all_saved_buffers, 'Buffer close all saved')
    map('<leader>tr', renameTab, 'Remane tab')
  end,
}
