local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

-- Resize with arrows
map("<Up>", ":resize -2<CR>", "Resize window up")
map("<Down>", ":resize +2<CR>", "Resize window down")
map("<Left>", ":vertical resize -2<CR>", "Resize window left")
map("<Right>", ":vertical resize +2<CR>", "Resize window right")

-- Buffers
map("<leader>bb", ":enew<CR>", "Buffer New")
map("<leader>br", ":e!<CR>", "Buffer Reset")

-- Window management
map("<leader>v", ":vsplit<CR>", "Split Window Vertically")
map("<leader>V", ":vsplit | ter<CR>", "Split Terminal Vertically")
map("<leader>h", ":split<CR>", "Split Window Horizontally")
map("<leader>H", ":split | ter<CR>", "Split Terminal Horizontally")
map("<leader>wj", ":vert ba<CR>", "Split all")

-- Navigate between splits
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
    "BibekBhusal0/bufstack.nvim",
    dir = "~/Code/bufstack.nvim",
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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = wrap_keys {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Window Left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Window Down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Window Up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Window Right" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "WIndow Previous" },
    },
  },
}
