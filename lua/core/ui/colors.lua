local M = {}

M.colors = {
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

function M.setup_highlights()
  local colors = M.colors

  -- StatusLine
  hl("StatusLine", { fg = colors.inactive_fg })
  hl("StatusLineNC", { fg = colors.inactive_fg })
  hl("StatusLineActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
  hl("StatusLineActiveSep", { fg = colors.active_bg })
  hl("StatusLineInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("StatusLineInactiveSep", { fg = colors.inactive_bg })
  hl("StatusLineMacro", { fg = colors.orange })

  -- TabLine
  hl("TabLineActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
  hl("TabLineActiveSep", { fg = colors.active_bg })
  hl("TabLineInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("TabLineInactiveSep", { fg = colors.inactive_bg })
  hl("TabLineFill", { bg = "NONE" })
  hl("TabLineModified", { fg = colors.red, bg = colors.inactive_bg })
  hl("TabLineModifiedActive", { fg = colors.red, bg = colors.active_bg })
  hl("TabLineTabActive", { fg = colors.active_fg, bg = colors.green, bold = true })
  hl("TabLineTabActiveSep", { fg = colors.green })
  hl("TabLineTabInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("TabLineTabInactiveSep", { fg = colors.inactive_bg })
end

return M
