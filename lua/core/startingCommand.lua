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
