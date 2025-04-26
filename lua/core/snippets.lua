-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
  float = { source = "always" },
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local function starting_command(condition, post_defer, pre_defer, dfr)
  if vim.fn.argc() > 0 then
    if condition(vim.fn.argv(0)) then
      if pre_defer then
        pre_defer(vim.fn.argv())
      end
      vim.cmd "bufdo bd!"
      vim.defer_fn(function()
        if post_defer then
          post_defer(vim.fn.argv())
        end
      end, dfr or 1)
    end
  end
end

starting_command(function(args)
  return args == "config"
end, function()
  vim.cmd("edit " .. vim.fn.stdpath "config" .. "/init.lua")
  vim.cmd "normal! zR"
end, function()
  vim.api.nvim_set_current_dir(vim.fn.stdpath "config")
end)

starting_command(function(args)
  return args == "ahk"
end, function()
  vim.cmd "edit script.ahk"
  vim.cmd "normal! zR"
end, function()
  vim.api.nvim_set_current_dir "~\\Desktop\\New folder\\ahk"
end)

starting_command(function(args)
  return args == "zen"
end, function()
  vim.cmd "Alpha"
end, function()
  vim.api.nvim_set_current_dir "~\\AppData\\Roaming\\zen\\Profiles\\krw1z2ua.Default (alpha)\\chrome"
end)

local obsidian_dir = "~/OneDrive - dafdodsakjf/Documents/Obsidian Vault"

starting_command(function(args)
  return args == "obsidian"
end, function()
  vim.cmd "ObsidianQuickSwitch"
end, function()
  vim.api.nvim_set_current_dir(obsidian_dir)
end)

starting_command(function(args)
  return string.sub(args, 1, 1) == ":"
end, function(args)
  vim.cmd(string.sub(table.concat(args, " "), 2))
end)
