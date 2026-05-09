-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd "normal! zz"
      end)
    end
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FileTypeConfig", { clear = true }),
  callback = function(args)
    if args.file:match "hyprland.overwrite.conf$" then
      vim.defer_fn(function()
        vim.cmd "set filetype=hyprlang"
      end, 1)
    elseif args.file:match "%.md$" then
      vim.opt_local.wrap = true
    end

    -- Pressing enter in commnet don't make another line comment
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
    -- Opening help in v split
    if args.filetype == "help" then
      vim.cmd "wincmd L"
      -- Hiding scrollbar
    elseif vim.tbl_contains({ "telescope", "mason", "lazy" }, args.filetype) then
      vim.opt_local.spell = false
    end
  end,
})

-- Lsp progress
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp." .. ev.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

-- Commandline hiding automotically
vim.opt.cmdheight = 0
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  group = vim.api.nvim_create_augroup("cmdline-auto-hide", { clear = true }),
  callback = function(args)
    local target_height = args.event == "CmdlineEnter" and 1 or 0
    if vim.opt_local.cmdheight:get() ~= target_height then
      vim.opt_local.cmdheight = target_height
      vim.cmd.redrawstatus()
    end
  end,
})
