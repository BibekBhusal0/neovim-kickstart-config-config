local M = {}
local fn = vim.fn
local opt_local = vim.api.nvim_set_option_value
local api = vim.api
local cur_buf = api.nvim_get_current_buf
local set_buf = api.nvim_set_current_buf
local get_opt = api.nvim_get_option_value

local function buf_index(bufnr)
  for i, value in ipairs(vim.t.bufs) do
    if value == bufnr then
      return i
    end
  end
end

-- M.next = function()
--   local bufs = vim.t.bufs
--   local curbufIndex = buf_index(cur_buf())

--   if not curbufIndex then
--     set_buf(vim.t.bufs[1])
--     return
--   end

--   set_buf((curbufIndex == #bufs and bufs[1]) or bufs[curbufIndex + 1])
-- end

-- M.prev = function()
--   local bufs = vim.t.bufs
--   local curbufIndex = buf_index(cur_buf())

--   if not curbufIndex then
--     set_buf(vim.t.bufs[1])
--     return
--   end

--   set_buf((curbufIndex == 1 and bufs[#bufs]) or bufs[curbufIndex - 1])
-- end

M.close_buffer = function(bufnr)
  bufnr = bufnr or cur_buf()

  if vim.bo[bufnr].buftype == "terminal" then
    vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
  else
    local curBufIndex = buf_index(bufnr)
    local bufhidden = vim.bo.bufhidden

    -- force close floating wins or nonbuflisted
    if api.nvim_win_get_config(0).zindex then
      vim.cmd "bw"
      return

      -- handle listed bufs
    elseif curBufIndex and #vim.t.bufs > 1 then
      local newBufIndex = curBufIndex == #vim.t.bufs and -1 or 1
      vim.cmd("b" .. vim.t.bufs[curBufIndex + newBufIndex])

      -- handle unlisted
    elseif not vim.bo.buflisted then
      local tmpbufnr = vim.t.bufs[1]
      api.nvim_set_current_win(vim.fn.bufwinid(bufnr))
      api.nvim_set_current_buf(tmpbufnr)
      vim.cmd("bw" .. bufnr)
      return
    else
      vim.cmd "enew"
    end

    if not (bufhidden == "delete") then
      vim.cmd("confirm bd" .. bufnr)
    end
  end

  vim.cmd "redrawtabline"
end


M.set_cleanbuf_opts = function(ft, buf)
  opt_local("buflisted", false, { buf = buf })
  opt_local("modifiable", false, { buf = buf })
  opt_local("buftype", "nofile", { buf = buf })
  opt_local("number", false, { scope = "local" })
  opt_local("list", false, { scope = "local" })
  opt_local("wrap", false, { scope = "local" })
  opt_local("relativenumber", false, { scope = "local" })
  opt_local("cursorline", false, { scope = "local" })
  opt_local("colorcolumn", "0", { scope = "local" })
  opt_local("foldcolumn", "0", { scope = "local" })
  opt_local("ft", ft, { buf = buf })
  vim.g[ft .. "_displayed"] = true
end


return M
