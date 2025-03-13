local maxChar = 27
local function prettifyFooterText(icon, text)
  local str = icon .. '   ' .. text
  if #str > maxChar then
    return str:sub(1, maxChar)
  else
    return str .. string.rep(' ', maxChar - #str)
  end
end

local quotes = {
  { 'Before software can be reusable it first has to be usable.', 'Ralph Johnson' },
  { 'There are two ways to write error-free programs; only the third one works.', 'Alan J. Perlis' },
  { 'Deleted code is debugged code.', 'Jeff Sickel' },
  { 'It works on my machine.', 'Every Developer Ever' },
  { 'It is not a bug, it is a feature.', 'Me' },
  { '6 hours of debugging can save you 5 minutes of reading documentation.', 'Random Reddit post' },
  { 'To replace programmers with bots, clients will have to accurately describe what they want, We are safe.', 'Random Reddit post' },
  { 'Never spend 6 minutes doing somthing by hand when you can spend 6 hours failing to automate it.', 'Random Reddit post' },
  { 'An idiot admires complexity, a genius admires simplicity.', 'Terry Davis' },
  { 'In theory there is no difference between theory and practice. In practice there is.', 'Yogi Berra' },
  { 'Think of how stupid the average person is, and realize half of them are stupider than that.', 'George Carlin' },
  { "Only 2 things are infinite, the universe and human stupidity, and I'm not sure about the universe.", 'Albert Einstein' },
  { 'Good Artists copy; Great artist steal.', 'Pablo Picasso' },
  { 'You know the bug is serous when you pause your Spotify music to focus.', 'Random Reddit post' },
  { 'Nothing is as permanent as a temporary solution that works', 'Random Reddit Post' },
}

local function get_random_quote()
  local current_time = os.time()
  local current_date = os.date('*t', current_time)
  local seed = current_date.month * 100 + current_date.day
  math.randomseed(seed)
  return quotes[math.random(#quotes)]
end

local function get_quote_for_footer()
  local maxChar = 60
  local quote_data = get_random_quote()

  local quote = quote_data[1]
  local author = quote_data[2]

  local formatted_lines = {}
  local words = {}

  for word in quote:gmatch '%S+' do
    table.insert(words, word)
  end

  local current_line = ''

  for _, word in ipairs(words) do
    if #current_line + #word + 1 > maxChar then
      table.insert(formatted_lines, current_line .. string.rep(' ', maxChar - #current_line))
      current_line = word
    else
      if #current_line > 0 then
        current_line = current_line .. ' ' .. word
      else
        current_line = word
      end
    end
  end

  if #current_line > 0 then
    table.insert(formatted_lines, current_line .. string.rep(' ', maxChar - #current_line))
  end

  if #formatted_lines > 0 then
    local author_line = string.rep(' ', maxChar - #author - 3) .. ' - ' .. author
    table.insert(formatted_lines, author_line)
  end

  return formatted_lines
end

local quote = get_quote_for_footer()

local function render()
  local alpha = require 'alpha'

  local function get_plugin_count()
    local stats = require('lazy').stats()
    return stats.loaded
  end

  local function get_lazy_startup_time()
    local success, stats = pcall(function()
      return require('lazy').stats()
    end)

    if success and stats.times.LazyDone and stats.times.LazyStart then
      return stats.times.LazyDone - stats.times.LazyStart
    else
      return 0
    end
  end

  local header = {
    [[                                                                     ]],
    [[       ████ ██████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      █████████ ███████████████████ ███   ███████████   ]],
    [[     █████████  ███    █████████████ █████ ██████████████   ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
  }

  local function button(sc, icon, txt, keybind, hl)
    local leader = 'SPC'
    local sc_ = sc:gsub('%s', ''):gsub(leader, '<leader>')

    local opts = {
      position = 'center',
      shortcut = sc,
      cursor = 3,
      width = 50,
      align_shortcut = 'right',
      hl_shortcut = hl or 'Keyword',
      hl = hl or 'Added',
    }
    if keybind then
      opts.keymap = { 'n', sc_, keybind, { noremap = true, silent = true, nowait = true } }
    end

    local function on_press()
      local key = vim.api.nvim_replace_termcodes(sc_ .. '<Ignore>', true, false, true)
      vim.api.nvim_feedkeys(key, 't', false)
    end

    return {
      type = 'button',
      val = icon .. '  > ' .. txt,
      on_press = on_press,
      opts = opts,
    }
  end

  local buttons_divider = {
    type = 'text',
    val = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    opts = { position = 'center', hl = 'Comment' },
  }

  local buttonGroup1 = {
    type = 'group',
    val = {
      {
        type = 'group',
        val = {
          button('f', '', 'Find file', ':Telescope <CR>'),
          button('r', '', 'Recent Files', ':Telescope oldfiles<CR>'),
          button('e', '󰙅', 'File Explorer', ':Neotree toggle position=left <CR>'),
        },
        opts = { spacing = 1 },
      },
      button('g', '󰊢', 'Git File Changes', ':Neotree float git_status <CR>'),
    },
  }

  local buttonGroup2 = {
    type = 'group',
    val = {
      button('p', '', 'Plugins', ':Lazy<CR>'),
      button('d', '󰾶', 'Change Directory', ':Proot<CR>'),
      button('h', '', 'Sessions', ':lua require("telescope") require("resession").load()<CR>'),
      button('c', '󱙓', 'Cheat Sheet', ':lua  require("nvcheatsheet").toggle()<CR>'),
      button('q', '󰅙', 'Quit', ':qa<CR>', 'DiagnosticError'),
    },
    opts = { spacing = 1 },
  }

  local buttons = {
    type = 'group',
    val = { buttonGroup1, buttons_divider, buttonGroup2 },
  }

  local function getFooter(val)
    return { type = 'text', val = val, opts = { position = 'center', hl = 'Ignore' } }
  end

  local function getPrettifiedFooter(icon, string)
    return getFooter(prettifyFooterText(icon, string))
  end

  local footer = {
    type = 'group',
    val = {
      getPrettifiedFooter('', string.format('%d plugins loaded', get_plugin_count())),
      getPrettifiedFooter('', string.format('Startup Time %d ms', get_lazy_startup_time())),
      getPrettifiedFooter('', string.format('Today: %s', os.date '%Y-%m-%d')),
      { type = 'padding', val = 2 },
      getFooter(quote),
    },
  }

  local content = {
    layout = {
      {
        type = 'text',
        val = header,
        opts = { position = 'center', hl = 'Type' },
      },
      { type = 'padding', val = 2 },
      buttons,
      { type = 'padding', val = 1 },
      footer,
    },
    opts = {},
  }

  alpha.setup(content)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  callback = function()
    vim.defer_fn(function()
      if vim.bo.filetype == 'alpha' then
        render()
        vim.cmd 'AlphaRedraw'
      end
    end, 5)
  end,
})

return {
  'goolord/alpha-nvim',
  config = render,
  lazy = 'leetcode.nvim' == vim.fn.argv(0, -1),
  cmd = 'Alpha',
}
