local M = {}

local ui = require "utils.ui_state"

local header = {
  [[                                                                   ]],
  [[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
  [[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
  [[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
  [[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
  [[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
  [[                                                                   ]],
}

local button_groups = {
  {
    { "f", "", "Find file", "lua require('fff').find_files()" },
    { "r", "", "Recent Files", "Telescope oldfiles" },
    { "e", "󰙅", "File Explorer", "Neotree toggle position=left" },
    { "g", "󰊢", "Git File Changes", "Neotree float git_status" },
  },
  {
    { "p", "", "Plugins", "Lazy" },
    { "m", "󰐻", "Mason (LSP, linter, DAP)", "Mason" },
  },
  {
    { "d", "󰾶", "Change Directory", "Zoxide" },
    { "s", "", "Sessions", 'lua require("telescope") require("resession").load()' },
    { "l", "", "Leetcode Dashboard", "Leet" },
    { "q", "󰅙", "Quit", "qa", "UIRed" },
  },
}

local function center(str, width)
  local str_len = vim.fn.strdisplaywidth(str)
  local shift = math.floor((width - str_len) / 2)
  shift = math.max(0, shift)
  return string.rep(" ", shift) .. str, shift
end

local button_line_to_cmd = {}
local button_line_to_col = {}
local button_lines = {}

function M.open()
  ui.hide_ui()
  require("core.ui.statuscolumn").hide()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "Dashboard")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "dashboard")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_buf_set_option(buf, "modifiable", true)

  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.list = false

  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)

  local lines = {}
  local highlights = {}
  button_line_to_cmd = {}
  button_line_to_col = {}
  button_lines = {}

  local top_padding = math.max(0, math.floor((height - 30) / 2) - 1)
  for _ = 1, top_padding do
    table.insert(lines, "")
  end

  -- Header
  for _, line in ipairs(header) do
    local centered, shift = center(line, width)
    table.insert(lines, centered)
    table.insert(highlights, { "DashboardHeader", #lines - 1, shift, shift + #line })
  end

  table.insert(lines, "")
  table.insert(lines, "")

  -- Buttons
  local button_width = 50
  for i, group in ipairs(button_groups) do
    for j, b in ipairs(group) do
      local sc, icon, txt, cmd, hl = unpack(b)

      -- Format: "icon  > txt                sc"
      local left_icon_part = icon .. "  > "
      local left_part = left_icon_part .. txt
      local right_part = sc
      local padding_len = button_width
        - vim.fn.strdisplaywidth(left_part)
        - vim.fn.strdisplaywidth(right_part)
      local padding = string.rep(" ", math.max(0, padding_len))
      local full_button_text = left_part .. padding .. right_part

      local centered, shift = center(full_button_text, width)
      table.insert(lines, centered)
      local line_idx = #lines - 1

      table.insert(button_lines, line_idx + 1)
      button_line_to_cmd[line_idx + 1] = cmd
      button_line_to_col[line_idx + 1] = shift + #icon + 2

      local button_hl = hl or "DashboardButton"
      table.insert(highlights, { button_hl, line_idx, shift, shift + #left_part })
      table.insert(
        highlights,
        { "DashboardShortcut", line_idx, shift + #left_part + #padding, shift + #full_button_text }
      )

      vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        sc,
        ":" .. cmd .. "<CR>",
        { noremap = true, silent = true, nowait = true }
      )

      if j < #group then
        table.insert(lines, "")
      end
    end

    if i < #button_groups then
      local divider = string.rep("─", button_width)
      local centered, shift = center(divider, width)
      table.insert(lines, centered)
      table.insert(highlights, { "DashboardDivider", #lines - 1, shift, shift + #divider })
    end
  end

  -- Footer
  table.insert(lines, "")
  table.insert(lines, "")
  local fortune = {}
  pcall(function()
    fortune = require("fortune").get_fortune()
  end)
  for _, line in ipairs(fortune) do
    local centered, shift = center(line, width)
    table.insert(lines, centered)
    table.insert(highlights, { "DashboardFooter", #lines - 1, shift, shift + #line })
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  for _, hl in ipairs(highlights) do
    if hl[3] >= 0 and hl[4] >= 0 then
      vim.api.nvim_buf_add_highlight(buf, -1, hl[1], hl[2], hl[3], hl[4])
    end
  end

  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Move cursor to first button
  if #button_lines > 0 then
    vim.api.nvim_win_set_cursor(win, { button_lines[1], button_line_to_col[button_lines[1]] })
  end

  -- Interactivity: restrict movement and handle Enter
  local function move_cursor(direction)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local target_idx = nil

    for idx, line_num in ipairs(button_lines) do
      if line_num == curr_line then
        if direction == "j" then
          target_idx = idx + 1
          if target_idx > #button_lines then
            target_idx = 1
          end
        else
          target_idx = idx - 1
          if target_idx < 1 then
            target_idx = #button_lines
          end
        end
        break
      end
    end

    if target_idx then
      local target_line = button_lines[target_idx]
      vim.api.nvim_win_set_cursor(0, { target_line, button_line_to_col[target_line] })
    else
      -- If not on a button line, go to first button
      vim.api.nvim_win_set_cursor(0, { button_lines[1], button_line_to_col[button_lines[1]] })
    end
  end

  local function map(key, fn)
    if type(fn) == "string" and #fn == 1 then
      local direction = fn
      fn = function()
        move_cursor(direction)
      end
    end
    vim.keymap.set("n", key, fn, { buffer = buf, nowait = true })
  end

  map("j", "j")
  map("<down>", "j")
  map("<up>", "k")
  map("k", "k")

  map("<CR>", function()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local cmd = button_line_to_cmd[curr_line]
    if cmd then
      vim.cmd(cmd)
    end
  end)

  -- Prevent other movements
  local keys_to_disable = { "h", "l", "w", "b", "e", "0", "$", "^", "G", "gg" }
  for _, key in ipairs(keys_to_disable) do
    map(key, "<Nop>")
  end

  -- UI restore on leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = function()
      ui.restore_ui()
    end,
  })
end

vim.api.nvim_create_user_command("Dashboard", function()
  M.open()
end, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.bo.filetype == "" then
      M.open()
    end
  end,
})

return M
