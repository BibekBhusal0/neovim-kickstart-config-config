local wrap_keys = require "utils.wrap_keys"

return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = wrap_keys {
    { "<leader>fo", ":Telescope file_browser<CR>", desc = "Telescope file browser" },
    {
      "<leader>fJ",
      ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
      desc = "Telescope file browser crr",
    },
  },

  config = function()
    local fb_actions = function(action)
      return function(...)
        require("telescope._extensions.file_browser.actions")[action](...)
      end
    end
    require("telescope").setup {
      extensions = {
        file_browser = {
          layout_strategy = "vertical",
          select_buffer = true,
          hide_parent_dir = true,
          collapse_dirs = true,
          prompt_path = true,
          dir_icon = "",
          git_status = true,
          mappings = {
            ["i"] = {
              ["<C-h>"] = fb_actions "backspace",
            },
            ["n"] = {
              ["<bs>"] = fb_actions "backspace",
              ["h"] = fb_actions "backspace",
              ["H"] = fb_actions "toggle_hidden",
              ["n"] = fb_actions "create",
              ["c"] = false,
            },
          },
        },
      },
    }
    require("telescope").load_extension "git_diffs"
  end,
}
