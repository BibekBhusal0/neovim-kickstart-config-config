return {
  "bluz71/vim-moonfly-colors",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyCursorColor = false
    vim.g.moonflyWinSeparator = 2
    vim.cmd [[colorscheme moonfly]]

    local colors = {
      active_fg = "#1e1e2e",
      active_bg = "#cba6f7",
      inactive_fg = "#cdd6f4",
      inactive_bg = "#45475a",
      orange = "#ff9e64",
      green = "#74dfa2",
      red = "#f31260",
    }

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
  end,
}
