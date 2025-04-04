local wrap_keys = require 'utils.wrap_keys'
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
      require('bufstack').setup { max_tracked = 400, shorten_path = true }
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
      { '<leader>w=', ':WindowsEqualize<CR>', desc = 'Window Equalize' },
      { '<leader>wf', ':WindowsMaximize<CR>', desc = 'Window Maximize' },
      { '<leader>wh', ':WindowsMaximizeHorizontally<CR>', desc = 'Window Maximize Horizontally' },
      { '<leader>wt', ':WindowsToggleAutowidth<CR>', desc = 'Window Toggle Autowidth' },
      { '<leader>wv', ':WindowsMaximizeVertically<CR>', desc = 'Window Maximize Vertically' },
    }, -- autoWidth is disabled so this is not needed
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
      { '<leader>wp', ":lua vim.api.nvim_set_current_win(require'window-picker'.pick_window())<CR>", desc = 'Window pick' },
    },
    opts = { hint = 'floating-big-letter' },
  }, -- picking window
}
