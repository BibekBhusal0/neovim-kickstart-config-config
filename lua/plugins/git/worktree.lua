local wrap_keys = require "utils.wrap_keys"

return {
  "polarmutex/git-worktree.nvim",
  enabled = false,
  keys = wrap_keys {
    {
      "<leader>gwn",
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      desc = "Git Worktree New (Telescope)",
    },
    {
      "<leader>gww",
      ":lua require('telescope').extensions.git_worktree.git_worktree()<CR>",
      desc = "Git Worktree (no)",
    },
    {
      "<leader>gws",
      function()
        require "utils.input"("Worktree Name", function(text)
          require("git-worktree").switch_worktree(text)
        end, "", 50, require("utils.icons").others.github .. "  ")
      end,
      desc = "Git Work tree switch",
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
