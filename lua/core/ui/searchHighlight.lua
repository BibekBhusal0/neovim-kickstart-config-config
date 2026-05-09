local map = require "utils.map"
local search_ns = vim.api.nvim_create_namespace "search_count"

local function clear_search()
  vim.cmd "nohlsearch"
  vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
end

local function update_search_count()
  vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
  vim.schedule(function()
    local count = vim.fn.searchcount { maxcount = 999, timeout = 100 }
    if count.total > 0 and count.current > 0 then
      local text = string.format("[%d/%d]", count.current, count.total)
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      -- Using 'Search' to match the highlighted word color
      vim.api.nvim_buf_set_extmark(0, search_ns, lnum, 0, {
        virt_text = { { text, "Search" } },
        virt_text_pos = "eol",
      })
    end
  end)
end

local function search_nav(key)
  return function()
    local ok, _ = pcall(vim.cmd, "normal! " .. vim.v.count1 .. key)
    if ok then
      vim.cmd "normal! zz"
      update_search_count()
    end
  end
end

-- Mappings
map("n", search_nav "n", "Next Search")
map("N", search_nav "N", "Prev Search")
map("*", search_nav "*", "Search Forward")
map("#", search_nav "#", "Search Backward")
map("<Esc>", clear_search, "Clear Highlight")
