local map = require "utils.map"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<ESC>", "Normal Mode", "v")

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

-- Duplicate Lines
map("<A-j>", ":copy '<-1<CR>gv=gv", "Duplicate Lines Below", "v")
map("<A-k>", ":copy '><CR>gv=gv", "Duplicate Lines Above", "v")
map("<A-k>", ":copy .-1<CR>", "Duplicate Line Above")
map("<A-j>", ":copy .<CR>", "Duplicate Line Below")

-- Move Lines
local function moveLine(dir)
  local count = vim.v.count1
  local mode = vim.api.nvim_get_mode().mode

  if mode:match "^v" or mode:match "^V" or mode == "\22" then
    local start = vim.fn.line "v"
    local finish = vim.fn.line "."
    if start > finish then
      start, finish = finish, start
    end

    local size = finish - start

    if dir == "up" then
      vim.cmd(start .. "," .. finish .. "m " .. (start - count - 1))
      start = start - count
    else
      vim.cmd(start .. "," .. finish .. "m " .. (finish + count))
      start = start + count
    end

    finish = start + size
    vim.fn.setpos("'<", { 0, start, 1, 0 })
    vim.fn.setpos("'>", { 0, finish, 1, 0 })
    vim.cmd "normal! gv"
  else
    if dir == "up" then
      vim.cmd("m .-" .. (count + 1))
    else
      vim.cmd("m .+" .. count)
    end
    vim.cmd "normal! =="
  end
end

map("K", function()
  moveLine "up"
end, "Move Line Up", { "n", "v" })

map("J", function()
  moveLine "down"
end, "Move Line Down", { "n", "v" })

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

local function toggle_line_numbers()
  local nu = vim.o.nu or vim.o.rnu
  vim.o.rnu = not nu
  vim.o.nu = not nu
end
map("<leader>nn", toggle_line_numbers, "Toggle Line Numbers")

map("zo", "za", "Toggle fold")
map("<Esc>", ":noh<CR>", "Clear Highlight")

local function toggle_statusline()
  local current_status = vim.o.laststatus
  if current_status == 2 then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 2
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

map("<leader>dy", copy_diagnostic, "Yank diagnostic message")
