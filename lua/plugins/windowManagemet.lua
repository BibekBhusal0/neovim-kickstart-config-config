local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

-- Resize with arrows
map("<Up>", ":resize -2<CR>", "Resize window up")
map("<Down>", ":resize +2<CR>", "Resize window down")
map("<Left>", ":vertical resize -2<CR>", "Resize window left")
map("<Right>", ":vertical resize +2<CR>", "Resize window right")

-- Buffers
map("<leader>bb", ":enew<CR>", "Buffer New")

-- Window management
map("<leader>v", ":vsplit<CR>", "Split window vertically")
map("<leader>V", ":vsplit | ter<CR>", "Split Terminal vertically")
map("<leader>wj", ":vert ba<CR>", "Split all")
map("<leader>S", ":split | ter<CR>", "Split Terminal horizontally")
map("<leader>br", ":e!<CR>", "Buffer Reset")

-- Navigate between splits
map("<C-k>", ":wincmd k<CR>", "Window up")
map("<C-j>", ":wincmd j<CR>", "Window down")
map("<C-h>", ":wincmd h<CR>", "Window left")
map("<C-l>", ":wincmd l<CR>", "Window right")
map("<C-p>", ":wincmd p<CR>", "Window Floating")

-- Tabs
map("<leader>to", ":tabnew<CR>", "Tab new")
map("<leader>tb", ":tab ba<CR>", "Tab new with current buffer")
map("<leader>tO", ":tabonly<CR>", "Tab Close other")
map("<leader>tx", ":tabclose<CR>", "Tab close")
map("<leader>tn", ":tabn<CR>", "Tab next")
map("<leader>tp", ":tabp<CR>", "Tab Previous")

local function gotoTab()
  require "utils.input"(" Tab ", function(text)
    vim.cmd("tabn " .. text)
  end, "", 9, "  ")
end
map("<leader>tg", gotoTab, "Tab goto")

local function list_all_buffers_in_current_tab()
  local bufnrs = vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.buflisted(bufnr) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  return bufnrs
end

local function close_all_saved_buffers()
  for _, e in ipairs(list_all_buffers_in_current_tab()) do
    vim.schedule(function()
      if vim.bo[e].modified == false then
        vim.cmd("bd " .. e)
      end
    end)
  end
end

map("<leader>bq", close_all_saved_buffers, "Buffer close all saved")

local function harpoon(a, b)
  return string.format(":lua require('harpoon.%s').%s()<CR>", a, b)
end

return {

  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = wrap_keys {
      { "<leader>xb", ":Bdelete<CR>", desc = "Quit Buffer" },
      { "<leader>xB", ":Bdelete!<CR>", desc = "Quit Buffer Force" },
      { "<leader>bx", ":Bdelete<CR>", desc = "Buffer Close" },
    },
  }, -- close buffer without closing tab

  {
    "tiagovla/scope.nvim",
    event = { "VimEnter" },
    config = function()
      require("scope").setup()
      map("<leader>bm", function()
        require "utils.input"("Tab Idx", function(text)
          vim.cmd("ScopeMoveBuf" .. text)
        end, "", 9, "  ")
      end, "Move Buffer")
    end,
  }, -- only show buffer from current tag

  {
    "stevearc/resession.nvim",
    keys = wrap_keys {
      { "<leader>sz", ':lua require("resession").delete()<CR>', desc = "Session Delete" },
      { "<leader>sl", ':lua require("resession").load()<CR>', desc = "Session Load" },
      { "<leader>ss", ':lua require("resession").save()<CR>', desc = "Session Save" },
      { "<leader>sS", ':lua require("resession").save_tab()<CR>', desc = "Session Save Tab" },
    },
    opts = {
      buf_filter = function(bufnr)
        local buftype = vim.bo.buftype
        if buftype == "help" then
          return true
        end
        if buftype ~= "" and buftype ~= "acwrite" then
          return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == "" then
          return false
        end
        return true
      end,
      extensions = {
        scope = {},
        cd = {},
      },
    },
  }, -- session management

  {
    "ThePrimeagen/harpoon",
    keys = wrap_keys {
      { "<leader>ha", harpoon("mark", "add_file"), desc = "Harpoon Add File" },
      { "<leader>hc", harpoon("mark", "clear_all"), desc = "Harpoon Clear Files" },
      { "<leader>hj", harpoon("ui", "nav_prev"), desc = "Harpoon Previous" },
      { "<leader>hk", harpoon("ui", "nav_next"), desc = "Harpoon Next" },
      { "<leader>hm", harpoon("ui", "toggle_quick_menu"), desc = "Harpoon Menu" },
      { "<leader>hn", harpoon("ui", "nav_next"), desc = "Harpoon Next" },
      { "<leader>hp", harpoon("ui", "nav_prev"), desc = "Harpoon Previous" },
      { "<leader>ht", harpoon("mark", "toggle_file"), desc = "Harpoon Toggle File" },
    },
  }, -- pinning files and quickly moving between them

  {
    "BibekBhusal0/bufstack.nvim",
    event = { "BufNewFile", "BufReadPost" },
    config = function()
      require("bufstack").setup { max_tracked = 400, shorten_path = true }
      map("gl", ":BufStackNext<CR>", "Buffer Next Recent")
      map("gh", ":BufStackPrev<CR>", "Buffer Prevevious Recent")
      map("<leader>bu", ":BufStackList<CR>", "Buffer Open List")
      map("<leader>bh", ":BufClosedList<CR>", "Buffer Closed List")
      map("<leader>ba", ":BufReopen<CR>", "Buffer Repoen")
    end,
  }, -- Reopen closed buffer and cycle through recently closed buffer

  {
    "anuvyklack/windows.nvim",
    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
    keys = wrap_keys {
      { "<leader>w=", ":WindowsEqualize<CR>", desc = "Window Equalize" },
      { "<leader>wf", ":WindowsMaximize<CR>", desc = "Window Maximize" },
      { "<leader>wh", ":WindowsMaximizeHorizontally<CR>", desc = "Window Maximize Horizontally" },
      { "<leader>wt", ":WindowsToggleAutowidth<CR>", desc = "Window Toggle Autowidth" },
      { "<leader>wv", ":WindowsMaximizeVertically<CR>", desc = "Window Maximize Vertically" },
    }, -- autoWidth is disabled so this is not needed
    -- event = { "BufNewFile", "BufReadPost" },
    cmd = {
      "WindowsEqualize",
      "WindowsMaximize",
      "WindowsMaximizeHorizontally",
      "WindowsMaximizeVertically",
      "WindowsToggleAutowidth",
      "WindowsEnableAutowidth",
      "WindowsDisableAutowidth",
    },
    config = function()
      vim.o.winwidth = 20
      vim.o.winminwidth = 15
      vim.o.equalalways = false
      require("windows").setup {
        autowidth = { enable = false },
        ignore = {
          buftype = { "quickfix" },
          filetype = {
            "codecompanion",
            "quickrun",
            "trouble",
            "qf",
            "noice",
            "NvimTree",
            "neo-tree",
            "undotree",
            "gundo",
          },
        },
      }
    end,
  }, -- split window autosize with better animations

  {
    "MisanthropicBit/winmove.nvim",
    keys = wrap_keys {
      { "<leader>ws", ":lua require'winmove'.start_mode('swap')<CR>", desc = "Window Swap mode" },
      { "<leader>wm", ":lua require'winmove'.start_mode('move')<CR>", desc = "Window Move mode" },
    },
  }, -- Easy move and swap split windows

  {
    "jyscao/ventana.nvim",
    cmd = { "VentanaTranspose", "VentanaShift", "VentanaShiftMaintailLinear" },
    keys = wrap_keys {
      { "<leader>wr", ":VentanaTranspose<CR>", desc = "Window Rotate(transpose)" },
      { "<leader>ww", ":VentanaShift<CR>", desc = "Window Shift" },
    },
  }, -- easy change layout of split window

  {
    "s1n7ax/nvim-window-picker",
    main = "window-picker",
    lazy = true,
    keys = wrap_keys {
      {
        "<leader>wp",
        ":lua vim.api.nvim_set_current_win(require'window-picker'.pick_window())<CR>",
        desc = "Window pick",
      },
    },
    opts = { hint = "floating-big-letter" },
  }, -- picking window
}
