local wrap_keys = require "utils.wrap_keys"
local get_file_name = function()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
end

local get_time_stamp = function()
  return os.date "!%Y-%m-%d_%H-%M-%S"
end

local get_file_name_and_timestamp = function()
  return get_file_name() .. "_" .. get_time_stamp()
end

local function take(opts)
  local sil = require "nvim-silicon"
  local options = vim.tbl_deep_extend("force", sil.options, opts)
  sil.shoot(options)
end

local save_to_desktop = function()
  take {
    output = "/home/bibek/Code/Screenshots/" .. get_file_name_and_timestamp() .. ".png",
  }
end

local sate_to_clipboard = function()
  take {
    output = nil,
    to_clipboard = true,
  }
end

return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    main = "nvim-silicon",

    keys = wrap_keys {
      { "<leader>sc", ":Silicon<CR>", desc = "Screenshot to Root directory", mode = { "n", "v" } },
      { "<leader>sC", sate_to_clipboard, desc = "Screenshot to clipboard", mode = { "n", "v" } },
      { "<leader>sd", save_to_desktop, desc = "Screenshot to Desktop", mode = { "n", "v" } },
    },

    opts = {
      line_offset = function(args)
        if args.range == 0 or args.range == nil then
          return 1
        end
        return args.line1
      end,

      font = "JetBrainsMono Nerd Font",
      theme = "DarkNeon",
      -- background = '#f76161',
      shadow_blur_radius = 14,
      shadow_offset_x = 20,
      shadow_offset_y = 20,
      shadow_color = "#27272a",
      background_image = vim.fn.stdpath "config" .. "/gradient.png",
      num_separator = "\u{258f}",

      output = function()
        return "./" .. get_file_name_and_timestamp() .. ".png"
      end,

      window_title = function()
        local repo_url = vim.fn.system "git config --get remote.origin.url"
        if repo_url and repo_url ~= "" then
          repo_url = vim.fn.trim(repo_url)
          local username, repo_name = repo_url:match "https://github.com/([^/]+)/([^/]+)"
          if username and repo_name then
            repo_name = repo_name:gsub("%.git$", "")
            return ("  " .. username .. "/" .. repo_name)
          end
        end
        return "   " .. get_file_name()
      end,
    },
  },
}
