local diagnostics = {
  error = '',
  warn = '',
  info = '󰋼',
  hint = '󰌵',
}

local symbols = {
  Array = '󰅪',
  Boolean = '◩',
  Class = '󰌗',
  Color = '󰏘',
  Constant = '󰇽',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '󰈙',
  Folder = '󰉋',
  Function = '󰊕',
  Interface = '',
  Key = '󰌋',
  Keyword = '󰌋',
  Method = '󰆧',
  Module = '',
  Namespace = '󰌗',
  Null = '󰟢',
  Number = '󰎠',
  Object = '󰅩',
  Operator = '󰆕',
  Package = '󰏗',
  Property = '',
  Reference = '',
  Snippet = '',
  String = '󰀬',
  Struct = '',
  Text = '󰉿',
  TypeParameter = '󰊄',
  Unit = '',
  Value = '󰎠',
  Variable = '󰆧',
}

local dap = {
  Breakpoint = '',
  BreakpointCondition = '',
  BreakpointRejected = '',
  LogPoint = '󰛿',
  Stopped = '󰁕',
}

local folder = {
  default = '',
  folder_empty = '󰉖',
  folder_empty_open = '󱞞',
  folder_open = '',
  fodler_symlink = '',
}

local git = {
  added = '',
  modified = '',
  removed = '',
  deleted = '',
  renamed = '󰁕',
  untracked = 'U',
  ignored = '',
  unstaged = '',
  staged = '',
  conflict = '',
}

local others = {
  github = '',
  ai = '',
  ai2 = '',
}

local pad_icons = function(inp)
  local icons = {}
  for k, v in pairs(inp) do
    icons[k] = v .. ' '
  end
  return icons
end

local get_padded_icon = function(name)
  if name == 'git' then
    return pad_icons(git)
  elseif name == 'folder' then
    return pad_icons(folder)
  elseif name == 'diagnostics' then
    return pad_icons(diagnostics)
  elseif name == 'symbols' then
    return pad_icons(symbols)
  end
  return {}
end

return {
  diagnostics = diagnostics,
  symbols = symbols,
  folder = folder,
  git = git,
  pad_icons = pad_icons,
  get_padded_icon = get_padded_icon,
  dap = dap,
  others = others,
}
