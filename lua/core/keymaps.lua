local map = require "utils.map"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- navigation in insert mode
map("<A-h>", "<ESC>^i", "Move to Begining of line", "i")
map("<A-l>", "<End>", "Move to End of line", "i")
map("<C-h>", "<Left>", "Move left", "i")
map("<C-l>", "<Right>", "Move right", "i")
map("<C-j>", "<Down>", "Move down", "i")
map("<C-k>", "<Up>", "Move up", "i")
map("jj", "<ESC>", "Normal Mode", "i")
map("<C-c>", "<Esc>", "Normal Mode", "i")
map("<C-o>", "<Esc>o", "Move to New Line", "i")
map("<C-]>", "<Esc>ldbi", "Delete Word", "i")
map("<leader>i", "`^", "Goto Last Insert")

-- Editing
map("H", "_", "Start of line")
map("L", "$", "End of line")
map("g,", "<cmd>norm A,<CR>", "Append a comma")
map("g.", "<cmd>norm A.<CR>", "Append a period")
map("g;", "<cmd>norm A;<CR>", "APPEND a simiconlan")

-- Opening file explorer
map("<leader>O", ':silent !nautilus "%:p:h" &<CR>', "Open Explorer (current file)")
map("<leader>P", function()
  vim.cmd('silent !nautilus "' .. vim.fn.getcwd() .. '" &')
end, "Open Explorer(current directory)")

-- Move and duplicate lines
map("K", ":m '<-2<CR>gv=gv", "Move Lines Up", "v")
map("J", ":m '>+1<CR>gv=gv", "Move Lines Down", "v")
map("<A-j>", ":copy '<-1<CR>gv=gv", "Duplicate Lines Below", "v")
map("<A-k>", ":copy '><CR>gv=gv", "Duplicate Lines Above", "v")
map("<A-k>", ":copy .-1<CR>", "Duplicate Line Above")
map("<A-j>", ":copy .<CR>", "Duplicate Line Below")
map("K", "<cmd>m .-2<CR>==", "Move Line Up")
map("J", "<cmd>m .+1<CR>==", "Move Line Down")

-- quit
map("<leader>sn", ":noautocmd w <CR>", "Save File Without formatting")
map("<leader>xx", ": q <CR>", "Quit File")
map("<leader>xX", ": q!<CR>", "Quit File force")
map("<leader>xa", ":qa<CR>", "Quit all Files")
map("<leader>xA", ":qa!<CR>", "Quit all Files force")
map("<leader>xt", ":tabclose<CR>", "Quit Tab")
map("<leader>xs", ":wincmd q<CR>", "Quit Split")

-- center while navigation
map("<C-d>", "<C-d>zz", "Scroll down")
map("<C-u>", "<C-u>zz", "Scroll up")

-- copy/paste to
-- system clipboard with leader y
map("<leader>y", '"+y', "Yank to system clipboard", { "n", "v" })
map("<leader>Y", '"+Y', "Yank line to system clipboard", { "n", "v" })

--When pasting don't yank and indent
map("p", "]p", "Paste")
map("P", "]P", "Paste before")
map("p", "\"_dP=']", "Paste", "x")
map("P", "\"_dP=']", "Paste before", "x")

-- yank all
map("<leader>k", "ggVGy", "Yank all")
map("<leader>K", 'ggVG"+y', "Yank all to System Clipboard")

-- select all
map("<A-a>", "ggVG", "Select all")

-- use black hole register
map("zc", '"_c', "Change to black hole register", { "n", "v" })
map("zd", '"_d', "Delete to black hole register", { "n", "v" })
map("zy", '"_y', "Yank to black hole register", { "n", "v" })
map("zx", '"_x', "Cut to black hole register", { "n", "v" })
map("zp", '"_dP', "Paste without yanking", "x")

-- terminal
map("<C-x>", "<C-\\><C-N>", "terminal escape terminal mode", "t")

-- Toggle line wrapping
map("<leader>lW", ":set wrap!<CR>", "Toggle line wrapping")

-- Alt keys to indent
map("<A-h>", "<gv", "Indent left", "v")
map("<A-l>", ">gv", "Indent right", "v")
map("<A-l>", ">>", "Indent right")
map("<A-h>", "<<", "Indent right")

map("zo", "za", "Toggle fold")
map("<Esc>", ":noh<CR>", "Clear Highlight")

local function toggle_statusline()
  local current_status = vim.o.laststatus
  if current_status == 3 then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 3
  end
end

local function toggle_tabline()
  local current_tabline = vim.o.showtabline
  if current_tabline == 2 then
    vim.o.showtabline = 0
  else
    vim.o.showtabline = 2
  end
end

map("<leader>ll", toggle_statusline, "Toggle Status Line")
map("<leader>bl", toggle_tabline, "Toggle Tab Line")

-- Diagnostic keymaps
map("<leader>dd", vim.diagnostic.open_float, "Diagnostic floating")
map("<leader>]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, "Jump next Diagnostic")
map("<leader>[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, "Jump Previous Diagnostic")

local copy_diagnostic = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum, col = pos[1] - 1, pos[2]

  local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
  if #diagnostics == 0 then
    return
  end

  -- Find the closest diagnostic on the current line
  local closest_diagnostic
  local min_distance = math.huge
  for _, d in ipairs(diagnostics) do
    local start_col = d.col
    local end_col = d.end_col or start_col
    -- Check if cursor is within the diagnostic range
    if col >= start_col and col <= end_col then
      closest_diagnostic = d
      break
    end
    -- Otherwise, keep track of the closest one
    local distance = math.min(math.abs(col - start_col), math.abs(col - end_col))
    if distance < min_distance then
      min_distance = distance
      closest_diagnostic = d
    end
  end

  vim.fn.setreg("+", closest_diagnostic.message)
end

local function undotree()
  vim.cmd "packadd nvim.undotree"
  vim.cmd "Undotree"
end

map("<leader>u", undotree, "Undo Tree")
map("<leader>dy", copy_diagnostic, "Yank diagnostic message")

local function select(node)
  return function()
    require("vim.treesitter._select")["select_" .. node](vim.v.count1)
  end
end

map("<leader>j", select "next", "Next sibling node", "x")
map("<leader>k", select "prev", "Prev sibling node", "x")
map("m", select "parent", "Select parent node", { "x", "o" })

local tabline = require "core.ui.tabline"

-- Buffer & Tab Management
local function close_others()
  local current = vim.api.nvim_get_current_buf()
  local bufs = tabline.get_buffers()
  for _, bufnr in ipairs(bufs) do
    if bufnr ~= current then
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
  end
end

local function close_left()
  local current = vim.api.nvim_get_current_buf()
  local bufs = tabline.get_buffers()
  for _, bufnr in ipairs(bufs) do
    if bufnr == current then
      break
    end
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end
end

local function close_right()
  local current = vim.api.nvim_get_current_buf()
  local bufs = tabline.get_buffers()
  local found = false
  for _, bufnr in ipairs(bufs) do
    if found then
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
    if bufnr == current then
      found = true
    end
  end
end

map("<leader>tr", function()
  require "utils.input"("Tab name", function(text)
    vim.api.nvim_tabpage_set_var(0, "name", text)
    vim.cmd "redrawtabline"
  end, "", 25, "󰓩 ")
end, "Rename tab")

local function close_all_saved_buffers()
  local bufnrs = vim.tbl_filter(function(bufnr)
    return 1 == vim.fn.buflisted(bufnr)
  end, vim.api.nvim_list_bufs())
  for _, e in ipairs(bufnrs) do
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(e) and vim.bo[e].modified == false then
        vim.cmd("bd " .. e)
      end
    end)
  end
end

map("<leader>bo", close_others, "Buffer Close others")
map("<leader>bH", close_left, "Buffer Close Left")
map("<leader>bL", close_right, "Buffer Close Right")
map("<leader>bq", close_all_saved_buffers, "Buffer Close Saved")
map("<Tab>", ":bnext<CR>", "Buffer Cycle Next")
map("<S-Tab>", ":bprev<CR>", "Buffer Cycle Prev")
