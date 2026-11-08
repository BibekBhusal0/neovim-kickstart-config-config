local map = require "utils.map"
local search_ns = vim.api.nvim_create_namespace "search_count"
vim.opt.hlsearch = true

local update_gen = 0

local function clear_search()
  update_gen = update_gen + 1
  vim.cmd "nohlsearch"
  vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
end

local function update_search_count()
  update_gen = update_gen + 1
  local gen = update_gen
  vim.schedule(function()
    if gen ~= update_gen then
      return
    end
    vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
    local count = vim.fn.searchcount { maxcount = 999, timeout = 100 }
    if count.total > 0 and count.current > 0 then
      local text = string.format("[%d/%d]", count.current, count.total)
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      vim.api.nvim_buf_set_extmark(0, search_ns, lnum, 0, {
        virt_text = { { text, "CurSearch" } },
        virt_text_pos = "eol",
      })
    end
  end)
end

map("<Esc>", clear_search, "Clear Highlight")

local group = vim.api.nvim_create_augroup("search_highlight_logic", { clear = true })

-- Auto-hide/update on cursor move
vim.api.nvim_create_autocmd("CursorMoved", {
  group = group,
  callback = function()
    if vim.v.hlsearch == 0 then
      return
    end

    local pattern = vim.fn.getreg "/"
    if pattern == "" then
      return
    end

    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local found = false
    local start = 0
    while true do
      local m = vim.fn.matchstrpos(line, pattern, start)
      if m[1] == "" then
        break
      end
      if col > m[2] and col <= m[3] then
        found = true
        break
      end
      start = m[3]
      if start <= m[2] then
        start = m[2] + 1
      end
    end

    if found then
      update_search_count()
    else
      update_gen = update_gen + 1
      vim.defer_fn(clear_search, 0)
    end
  end,
})
