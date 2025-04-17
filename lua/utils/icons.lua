local diagnostics = {
  error = "",
  warn = "",
  info = "󰋼",
  hint = "󰌵",
}

local symbols = {
  Array = "󰅪",
  Boolean = "󰨙",
  Class = "󰌗",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = " ",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰊕",
  Interface = "",
  Key = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "󰅩",
  Operator = "󰆕",
  Package = "󰏗",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  String = " ",
  Struct = "󰆼",
  Text = "󰉿",
  TypeParameter = "",
  Unit = "󰑭",
  Value = "󰎠",
  Variable = "󰆧",
}

local dap = {
  Breakpoint = "●",
  BreakpointCondition = "",
  BreakpointRejected = "◌",
  LogPoint = "󰝶",
  Stopped = "󰁕",
}

local folder = {
  default = "",
  folder_empty = "󰉖",
  folder_empty_open = "󱞞",
  folder_open = "",
  fodler_symlink = "",
}

local git = {
  added = "",
  modified = "",
  removed = "",
  deleted = "",
  renamed = "󰁕",
  untracked = "U",
  ignored = "",
  unstaged = "",
  staged = "",
  conflict = "",
}

local others = {
  github = "",
  git = "󰊢",
  ai = "",
  ai2 = "",
}

local pad_icons = function(inp)
  local icons = {}
  for k, v in pairs(inp) do
    icons[k] = v .. " "
  end
  return icons
end

local icons = {
  git = git,
  folder = folder,
  diagnostics = diagnostics,
  symbols = symbols,
  dap = dap,
  others = others,
}

local get_padded_icon = function(name)
  local icon = icons[name]
  if icon then
    return pad_icons(icon)
  else
    return {}
  end
end

return vim.tbl_extend("force", icons, {
  get_padded_icon = get_padded_icon,
  pad_icons = pad_icons,
})
