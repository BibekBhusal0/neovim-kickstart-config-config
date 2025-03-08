local diagnostics = {
  error = ' ',
  warn = ' ',
  info = ' ',
  hint = ' ',
}

local symbols = {
  Array = '󰅪 ',
  Boolean = '◩ ',
  Class = '󰌗 ',
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
  Key = '󰌋 ',
  Keyword = '󰌋',
  Method = '󰆧 ',
  Module = ' ',
  Namespace = '󰌗 ',
  Null = '󰟢 ',
  Number = '󰎠 ',
  Object = '󰅩 ',
  Operator = '󰆕',
  Package = ' ',
  Property = '',
  Reference = '',
  Snippet = '',
  String = ' ',
  Struct = '',
  Text = '󰉿',
  TypeParameter = '󰊄',
  Unit = '',
  Value = '󰎠',
  Variable = '󰆧',
}

local folder = {
  default = '',
  folder_empty = '󰉖',
  folder_empty_open = '󱞞',
  folder_open = '',
  fodler_symlink = '',
}

local git = {
  added = 'A', -- or "✚",
  modified = 'M', -- or "",
  deleted = '󰩹',
  renamed = '󰁕',
  untracked = 'U',
  ignored = '',
  unstaged = '',
  staged = '',
  conflict = '',
}

return {
  diagnostics = diagnostics,
  symbols = symbols,
  folder = folder,
  git = git,
}
