--[[ local short_quotes = {
  { "An idiot admires complexity, a genius admires simplicity.", "Terry Davis" },
  { "Before software can be reusable it first has to be usable.", "Ralph Johnson" },
  { "Deleted code is debugged code.", "Jeff Sickel" },
  { "It is not a bug, it is a feature.", "Me" },
  { "It works on my machine.", "Every Developer Ever" },
  { "The best error message is the one that never shows up.", "Thomas Fuchs" },
  { "You know the bug is serous when you pause your Spotify music to focus.", "Random Reddit post" },
  { "6 hours of debugging can save you 5 minutes of reading documentation.", "Random Reddit post" },
  { "Good Artists copy; Great artist steal.", "Pablo Picasso" },
  { "Gotta concentrate, against the clock I rase,got no time to waste, I am already late, I got a marathon pased", "Eminiem" },
}
local long_quotes = {
  { "In theory there is no difference between theory and practice. In practice there is.", "Yogi Berra" },
  { "Never spend 6 minutes doing somthing by hand when you can spend 6 hours failing to automate it.", "Random Reddit post" },
  { "Nothing is as permanent as a temporary solution that works", "Random Reddit Post" },
  { "Only 2 things are infinite, the universe and human stupidity, and I'm not sure about the universe.", "Albert Einstein" },
  { "There are three things programmers struggle withㅤㅤㅤㅤ  1. Naming variabls, 2. Off by one errors", "Fireship video comment" },
  { "There are two ways to write error-free programs; only the third one works.", "Alan J. Perlis" },
  { "Think of how stupid the average person is, and realize half of them are stupider than that.", "George Carlin" },
  { "Time is free but somehow priceless, so whatch how you spend it wisely", "Central Cee" },
  { "To replace programmers with bots, clients will have to accurately describe what they want, We are safe.", "Random Reddit post" },
} ]]

-- Logic to hide lualine and bufferline dynimically when alpha opens

local ui = require "utils.ui_state"
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = ui.hide_ui,
})

-- Restore when leaving Alpha filetype
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.filetype == "alpha" then
      ui.restore_ui()
    end
  end,
})

local function render()
  local alpha = require "alpha"

  local header = {
    [[                                                                   ]],
    [[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
    [[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
    [[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
    [[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
    [[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
    [[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
    [[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
    [[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
    [[                                                                   ]],
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
    val = "───────────────────────────────────────────────────",
    opts = { position = "center", hl = "comment" },
  }

  local function create_button_group(buttons, divider)
    local group = { type = "group", val = {} }
    local num_buttons = #buttons
    if num_buttons > 1 then
      local inner_group = { type = "group", val = {}, opts = { spacing = 1 } }
      for i = 1, num_buttons - 1 do
        table.insert(inner_group.val, button(unpack(buttons[i])))
      end
      table.insert(group.val, inner_group)
    end
    if num_buttons > 0 then
      table.insert(group.val, button(unpack(buttons[num_buttons])))
    end
    if divider then
      table.insert(group.val, buttons_divider)
    end
    return group
  end

  local file_buttons = create_button_group({
    { "f", "", "Find file", ":Telescope find_files<CR>" },
    { "r", "", "Recent Files", ":Telescope oldfiles<CR>" },
    { "e", "󰙅", "File Explorer", ":Neotree toggle position=left <CR>" },
    { "g", "󰊢", "Git File Changes", ":Neotree float git_status <CR>" },
  }, true)

  local popup_buttons = create_button_group({
    { "p", "", "Plugins", ":Lazy<CR>" },
    { "m", "󰐻", "Mason (LSP, linter, DAP)", ":Mason<CR>" },
    -- { "a", require("utils.icons").others.ai, "MCP hub", ":MCPHub<CR>", "@constructor" },
  }, true)

  local other_buttons = create_button_group {
    { "d", "󰾶", "Change Directory", ":lua require('telescope').extensions.zoxide.list()<CR>" },
    { "s", "", "Sessions", ':lua require("telescope") require("resession").load()<CR>' },
    { "l", "", "Leetcode Dashboard", ":Leet<CR>" },
    { "q", "󰅙", "Quit", ":qa<CR>", "DiagnosticError" },
  }

  local buttons = { type = "group", val = { file_buttons, popup_buttons, other_buttons } }

  local function get_fortune()
    local fortune = require("fortune").get_fortune()
    local items = {}
    for _, val in ipairs(fortune) do
      local item = { type = "text", val = val, opts = { position = "center", hl = "Ignore" } }
      table.insert(items, item)
    end
    return items
  end

  local footer = { type = "group", val = get_fortune() }

  local content = {
    layout = {
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
  dependencies = {
    "rubiin/fortune.nvim",
    opts = { display_format = "long", content_type = "quotes" },
  },
  config = render,
  lazy = "" ~= vim.fn.argv(0, -1),
  cmd = "Alpha",
}
