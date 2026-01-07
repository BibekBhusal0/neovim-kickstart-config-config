local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

local function diffViewTelescopeFileHistory()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local themes = require "telescope.themes"
  local builtin = require "telescope.builtin"
  builtin.git_files(themes.get_dropdown {
    prompt_title = "Select File for History",
    previewer = false,
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("DiffviewFileHistory " .. selection.path)
        end
      end)
      return true
    end,
  })
end

local function diffViewTelescopeCompareBranches()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local themes = require "telescope.themes"
  local builtin = require "telescope.builtin"

  builtin.git_branches(themes.get_dropdown {
    prompt_title = "Select First Branch",
    previewer = false,
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()
        actions.close(prompt_bufnr)
        if #selections > 2 then
          vim.notify "Must select 1 or 2 branches"
          return
        end
        local old = #selections == 0 and action_state.get_selected_entry().ordinal
          or selections[1].value
        if #selections == 2 then
          local new = string.sub(selections[2].value, 1, 8)
          vim.cmd(string.format("DiffviewOpen %s..%s", old, new))
        else
          vim.cmd(string.format("DiffviewOpen %s", old))
        end
        vim.cmd [[stopinsert]]
      end)
      return true
    end,
  })
end

map("<leader>gdb", diffViewTelescopeCompareBranches, "Diffview compare branches")
map("<leader>gdF", diffViewTelescopeFileHistory, "Diffview file history Telescope")

return {
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Diffview", "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      hooks = {
        view_post_layout = function()
          if package.loaded["windows"] then
            vim.cmd "WindowsDisableAutowidth"
          end
        end,
      },
    },
    keys = wrap_keys {
      { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Diffview file history Current File" },
      { "<leader>gdh", ":DiffviewFileHistory<CR>", desc = "Diffview file history" },
      { "<leader>gdo", ":DiffviewOpen<CR>", desc = "DiffView Open" },
      { "<leader>gdx", ":DiffviewClose<CR>", desc = "Diffview close" },
    },
  },

  {
    "paopaol/telescope-git-diffs.nvim",
    keys = wrap_keys {
      {
        "<leader>gdc",
        ":Telescope git_diffs  diff_commits previewer=false<CR>",
        desc = "Diffview Compare commmits",
      },
    },
    config = function()
      require("telescope").setup {
        extensions = { git_diffs = { enable_preview_diff = false } },
      }
    end,
  },
}
