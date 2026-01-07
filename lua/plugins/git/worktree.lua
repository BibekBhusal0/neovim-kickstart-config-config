local wrap_keys = require "utils.wrap_keys"

return {
  "polarmutex/git-worktree.nvim",
  keys = wrap_keys {
    {
      "<leader>gwn",
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      desc = "Git Worktree New (Telescope)",
    },
    {
      "<leader>gww",
      ":lua require('telescope').extensions.git_worktree.git_worktree()<CR>",
      desc = "Git Worktree Switch",
    },
  },

  config = function()
    local Hooks = require "git-worktree.hooks"
    local config = require "git-worktree.config"
    Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
    Hooks.register(Hooks.type.DELETE, function(opts)
      vim.notify("Deleted " .. opts.path)
      vim.cmd(config.update_on_change_command)
    end)
    require("telescope").load_extension "git_worktree"
  end,
}
