-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  float = {
    border = "rounded",
    source = "if_many",
    focusable = true,
    severity_sort = true,
    header = "",
  },
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

local obsidian_dir = "/home/bibek/Documents/obsidian.md"

local function is_arg(expected_arg)
  return function(args)
    return args == expected_arg
  end
end

local commands = {
  {
    condition = is_arg "config",
    post_defer = function()
      vim.cmd("edit " .. vim.fn.stdpath "config" .. "/init.lua")
      vim.cmd "normal! zR"
    end,
    pre_defer = function()
      vim.api.nvim_set_current_dir(vim.fn.stdpath "config")
    end,
  },

  {
    condition = is_arg "hypr",
    post_defer = function()
      vim.cmd "edit overwrite/hyprland.overwrite.conf"
      vim.cmd "normal! zR"
    end,
    pre_defer = function()
      vim.api.nvim_set_current_dir "/home/bibek/Code/omarchy-overrides"
    end,
  },

  {
    condition = is_arg "zen",
    post_defer = function()
      vim.cmd "Alpha"
    end,
    pre_defer = function()
      vim.api.nvim_set_current_dir "/home/bibek/.zen/pf761izm.Default Profile/chrome"
    end,
  },

  {
    condition = is_arg "obsidian",
    post_defer = function()
      vim.cmd "Obsidian quick_switch"
    end,
    pre_defer = function()
      vim.api.nvim_set_current_dir(obsidian_dir)
    end,
  },

  {
    condition = is_arg "obsidianConfig",
    post_defer = function()
      vim.cmd "e .obsidian.vimrc"
    end,
    pre_defer = function()
      vim.api.nvim_set_current_dir(obsidian_dir)
    end,
  },

  {
    condition = function(args)
      return string.sub(args, 1, 1) == ":"
    end,
    post_defer = function(args)
      vim.cmd(string.sub(table.concat(args, " "), 2))
    end,
  },
}

for _, cmd in ipairs(commands) do
  starting_command(cmd.condition, cmd.post_defer, cmd.pre_defer, cmd.dfr)
end
