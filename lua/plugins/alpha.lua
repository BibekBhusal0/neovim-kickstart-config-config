local maxChar = 25
local function prettifyFooterText(icon, text)
  local str = icon .. "  " .. text
  if #str > maxChar then
    return str:sub(1, maxChar)
  else
    return str .. string.rep(" ", maxChar - #str)
  end
end

local quotes = {
  { "6 hours of debugging can save you 5 minutes of reading documentation.", "Random Reddit post" },
  { "An idiot admires complexity, a genius admires simplicity.", "Terry Davis" },
  { "Before software can be reusable it first has to be usable.", "Ralph Johnson" },
  { "Deleted code is debugged code.", "Jeff Sickel" },
  { "Good Artists copy; Great artist steal.", "Pablo Picasso" },
  {
    "Gotta concentrate, against the clock I rase,got no time to waste, I am already late, I got a marathon pased",
    "Eminiem",
  },
  {
    "In theory there is no difference between theory and practice. In practice there is.",
    "Yogi Berra",
  },
  { "It is not a bug, it is a feature.", "Me" },
  { "It works on my machine.", "Every Developer Ever" },
  {
    "Never spend 6 minutes doing somthing by hand when you can spend 6 hours failing to automate it.",
    "Random Reddit post",
  },
  { "Nothing is as permanent as a temporary solution that works", "Random Reddit Post" },
  {
    "Only 2 things are infinite, the universe and human stupidity, and I'm not sure about the universe.",
    "Albert Einstein",
  },
  { "The best error message is the one that never shows up.", "Thomas Fuchs" },
  {
    "There are three things programmers struggle withㅤㅤㅤㅤ  1. Naming variabls, 2. Off by one errors",
    "Fireship video comment",
  },
  {
    "There are two ways to write error-free programs; only the third one works.",
    "Alan J. Perlis",
  },
  {
    "Think of how stupid the average person is, and realize half of them are stupider than that.",
    "George Carlin",
  },
  { "Time is free but somehow priceless, so whatch how you spend it wisely", "Central Cee" },
  {
    "To replace programmers with bots, clients will have to accurately describe what they want, We are safe.",
    "Random Reddit post",
  },
  {
    "You know the bug is serous when you pause your Spotify music to focus.",
    "Random Reddit post",
  },
}

local function get_random_quote()
  local current_time = os.time()
  local current_date = os.date("*t", current_time)
  local seed = current_date.month * 100 + current_date.day
  math.randomseed(seed)
  return quotes[math.random(#quotes)]
end

local function get_quote_for_footer()
  local maxChars = 60
  local quote_data = get_random_quote()

  local quote = quote_data[1]
  local author = quote_data[2]

  local formatted_lines = {}
  local words = {}

  for word in quote:gmatch "%S+" do
    table.insert(words, word)
  end

  local current_line = ""

  for _, word in ipairs(words) do
    if #current_line + #word + 1 > maxChars then
      table.insert(formatted_lines, current_line .. string.rep(" ", maxChars - #current_line))
      current_line = word
    else
      if #current_line > 0 then
        current_line = current_line .. " " .. word
      else
        current_line = word
      end
    end
  end

  if #current_line > 0 then
    table.insert(formatted_lines, current_line .. string.rep(" ", maxChars - #current_line))
  end

  if #formatted_lines > 0 then
    local author_line = string.rep(" ", maxChars - #author - 3) .. " - " .. author
    table.insert(formatted_lines, author_line)
  end

  return formatted_lines
end

local quote = get_quote_for_footer()

local function render()
  local alpha = require "alpha"

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
    local leader = "SPC"
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
      position = "center",
      shortcut = sc,
      cursor = 3,
      width = 50,
      align_shortcut = "right",
      hl_shortcut = hl or "Keyword",
      hl = hl or "Added",
    }
    if keybind then
      opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true, nowait = true } }
    end

    local function on_press()
      local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
      vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
      type = "button",
      val = icon .. "  > " .. txt,
      on_press = on_press,
      opts = opts,
    }
  end

  local buttons_divider = {
    type = "text",
    val = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
    opts = { position = "center", hl = "Comment" },
  }

  local buttonGroup1 = {
    type = "group",
    val = {
      {
        type = "group",
        val = {
          button("f", "", "Find file", ":Telescope find_files<CR>"),
          button("r", "", "Recent Files", ":Telescope oldfiles<CR>"),
          button("e", "󰙅", "File Explorer", ":Neotree toggle position=left <CR>"),
          button("m", require("utils.icons").others.ai, "MCp", ":MCPHub<CR>"),
        },
        opts = { spacing = 1 },
      },
      button("g", "󰊢", "Git File Changes", ":Neotree float git_status <CR>"),
    },
  }

  local buttonGroup2 = {
    type = "group",
    val = {
      button("p", "", "Plugins", ":Lazy<CR>"),
      button("b", "", "Search Browser Bookmarks", ":BrowserBookmarks<CR>"),
      button("l", "", "Leetcode Dashboard", ":Leet<CR>"),
      button("d", "󰾶", "Change Directory", ":Proot<CR>"),
      button("s", "", "Sessions", ':lua require("telescope") require("resession").load()<CR>'),
      button("q", "󰅙", "Quit", ":qa<CR>", "DiagnosticError"),
    },
    opts = { spacing = 1 },
  }

  local buttons = { type = "group", val = { buttonGroup1, buttons_divider, buttonGroup2 } }

  local function getFooter(val)
    return { type = "text", val = val, opts = { position = "center", hl = "Ignore" } }
  end

  local function getPrettifiedFooter(icon, string)
    return getFooter(prettifyFooterText(icon, string))
  end

  local footer = {
    type = "group",
    val = {
      getPrettifiedFooter("", string.format("Today: %s", os.date "%Y-%m-%d")),
      { type = "padding", val = 1 },
      getFooter(quote),
    },
  }

  local content = {
    layout = {
      { type = "padding", val = 1 },
      { type = "text", val = header, opts = { position = "center", hl = "Type" } },
      { type = "padding", val = 2 },
      buttons,
      { type = "padding", val = 2 },
      footer,
    },
    opts = {},
  }

  alpha.setup(content)
end

return {
  "goolord/alpha-nvim",
  config = render,
  lazy = "" ~= vim.fn.argv(0, -1),
  cmd = "Alpha",
}
