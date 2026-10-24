return {
  "bluz71/vim-moonfly-colors",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyCursorColor = false
    vim.g.moonflyWinSeparator = 2
    vim.cmd [[colorscheme moonfly]]

    -- Catppuccin fallbacks; overridden by the Omarchy theme when resolvable
    local mapping = {
      active_fg = { key = "background", hex = "#1e1e2e" },
      active_bg = { key = "accent", hex = "#cba6f7" },
      inactive_fg = { key = "foreground", hex = "#cdd6f4" },
      inactive_bg = { key = "muted", hex = "#45475a" },
    }

    local state_dir = vim.fn.expand "~/.local/state/omarchy/current"
    local theme_file = state_dir .. "/theme/colors.toml"

    local function read_colors()
      local colors = {}
      for dest, def in pairs(mapping) do
        colors[dest] = def.hex
      end
      local f = io.open(theme_file)
      if f then
        for line in f:lines() do
          local key, value = line:match '^([%a%d_-]+)%s*=%s*"([^"]+)"'
          if key then
            for dest, def in pairs(mapping) do
              if def.key == key then
                colors[dest] = value
              end
            end
          end
        end
        f:close()
      end
      return colors
    end

    local colors = read_colors()

    local function hl(name, val)
      if val.bg == nil then
        val.bg = "NONE"
      end
      vim.api.nvim_set_hl(0, name, val)
    end
    local function setup_highlights()
      hl("UIActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
      hl("UIActiveSep", { fg = colors.active_bg })
      hl("UIInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
      hl("UIInactiveSep", { fg = colors.inactive_bg })

      hl("UIRed", { fg = colors.red })
      hl("UIOrange", { fg = colors.orange })

      -- Transparent backgorund of tabline and status line
      hl("TabLineFill", {})
      hl("TabLine", {})
      hl("StatusLine", {})
      hl("StatusLineNC", {})

      hl("DashboardHeader", { fg = colors.active_bg })
      hl("DashboardButton", { fg = colors.green })
      hl("DashboardShortcut", { fg = colors.orange, bold = true })
      hl("DashboardFooter", { fg = colors.active_bg, italic = true, bold = true })
      hl("DashboardDivider", { fg = colors.inactive_bg })
      hl("WinSeparator", { fg = "#999999" })
    end

    setup_highlights()
    require("utils.transparency").apply_transparency()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = setup_highlights,
    })

    -- tmux panes outlive omarchy terminal restarts, so watch for theme swaps
    -- instead of relying on a nvim restart
    if vim.fn.isdirectory(state_dir) == 1 then
      local watching = false
      vim.uv.new_fs_event():start(state_dir, {}, function()
        if watching then
          return
        end
        watching = true
        vim.defer_fn(function()
          watching = false
          colors = read_colors()
          setup_highlights()
        end, 500)
      end)
    end
  end,
}
