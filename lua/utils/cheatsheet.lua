-- Cheat Sheet scrapped from :https://vim.rtorr.com/
local copiedMaps = {
    ["Global"] = {
        { "open help for keyword",   ":h[elp] keyword" },
        { "save file as",            ":sav[eas] file" },
        { "close current pane",      ":clo[se]" },
        { "open a terminal window",  ":ter[minal]" },
        { "open main page for word", "K" },
    },
    ["Cursor movement"] = {
        { "move cursor left",                                 "h" },
        { "move cursor down",                                 "j" },
        { "move cursor up",                                   "k" },
        { "move cursor right",                                "l" },
        { "move cursor down (multi-line text)",               "gj" },
        { "move cursor up (multi-line text)",                 "gk" },
        { "move to top of screen",                            "H" },
        { "move to middle of screen",                         "M" },
        { "move to bottom of screen",                         "L" },
        { "jump forwards to the start of a word",             "w" },
        { "jump forwards to the end of a word",               "e" },
        { "jump backwards to the start of a word",            "b" },
        { "jump backwards to the end of a word",              "ge" },
        { "jump to the start of the line",                    "0" },
        { "jump to the end of the line",                      "$" },
        { "go to the first line of the document",             "gg" },
        { "go to the last line of the document",              "G" },
        { "go to line 5",                                     "5gg or 5G" },
        { "move to local declaration",                        "gd" },
        { "move to global declaration",                       "gD" },
        { "jump to next occurrence of character x",           "fx" },
        { "repeat previous f, t, F or T movement",            ";" },
        { "center cursor on screen",                          "zz" },
        { "position cursor on top of the screen",             "zt" },
        { "position cursor on bottom of the screen",          "zb" },
        { "screen down one line (without moving cursor)",     "Ctrl + e" },
        { "screen up one line (without moving cursor)",       "Ctrl + y" },
        { "screen up one page (cursor to last line)",         "Ctrl + b" },
        { "screen down one page (cursor to first line)",      "Ctrl + f" },
        { "cursor and screen down 1/2 page",                  "Ctrl + d" },
        { "cursor and screen up 1/2 page",                    "Ctrl + u" },
        { "cursor to matching bracket",                       "%" },
        { "jump forwards to start of a word",                 "W" },
        { "jump forwards to end of a word",                   "E" },
        { "jump backwards to start of a word",                "B" },
        { "jump backwards to end of a word",                  "gE" },
        { "jump to first non-blank character of line",        "^" },
        { "jump to last non-blank character of line",         "g_" },
        { "jump to before next occurrence of character x",    "tx" },
        { "jump to previous occurrence of character x",       "Fx" },
        { "jump to after previous occurrence of character x", "Tx" },
        { "repeat previous f, t, F or T movement, backwards", "," },
        { "jump to next paragraph ",                          "}" },
        { "jump to previous paragraph ",                      "{" },
    },
    ["Insert mode"] = {
        { "insert before the cursor",                         "i" },
        { "insert at the beginning of the line",              "I" },
        { "insert after the cursor",                          "a" },
        { "insert at the end of the line",                    "A" },
        { "insert at the end of the word",                    "ea" },
        { "exit insert mode",                                 "Esc or Ctrl + c" },
        { "append a new line below",                          "o" },
        { "append a new line above",                          "O" },
        { "delete word before in insert mode",                "Ctrl + w" },
        { "delete character before cursor in insert mode",    "Ctrl + h" },
        { "add line break at cursor position in insert mode", "Ctrl + j" },
        { "indent line one shiftwidth in insert mode",        "Ctrl + t" },
        { "de-indent line one shiftwidth in insert mode",     "Ctrl + d" },
        { "insert the contents of register x",                "Ctrl + rx" },
    },
    ["Editing"] = {
        { "replace a single character.",              "r" },
        { "reflow paragraph",                         "gwip" },
        { "switch case up to motion",                 "g~" },
        { "change to lowercase up to motion",         "gu" },
        { "change to uppercase up to motion",         "gU" },
        { "change entire line",                       "cc" },
        { "change to the end of the line",            "c$ or C" },
        { "change entire word",                       "ciw" },
        { "transpose two letters", "xp" },
        { "undo",                                     "u" },
        { "restore (undo) last changed line",         "U" },
        { "redo",                                     "Ctrl + r" },
        { "repeat last command",                      "." },
        { "join line below with one space ",          "J" },
        { "join line below without space ",           "gJ" },
        { "change to the end of the word",            "cw or ce" },
        { "delete character and substitute text ",    "s" },
        { "delete line and substitute text ",         "S" },
    },
    ["Marking text (visual mode)"] = {
        { "start linewise visual mode",       "V" },
        { "move to other end of marked area", "o" },
        { "start visual block mode",          "Ctrl + v" },
        { "move to other corner of block",    "O" },
        { "mark a word",                      "aw" },
        { "a block with ()",                  "ab" },
        { "a block with {}",                  "aB" },
        { "a block with <> tags",             "at" },
        { "inner block with ()",              "ib" },
        { "inner block with {}",              "iB" },
        { "inner block with <> tags",         "it" },
        { "exit visual mode",                 "Esc or Ctrl + c" },
    },
    ["Visual commands"] = {
        { "shift text right",                ">" },
        { "shift text left",                 "<" },
        { "yank marked text",                "y" },
        { "delete marked text",              "d" },
        { "switch case",                     "~" },
        { "change marked text to lowercase", "u" },
        { "change marked text to uppercase", "U" },
    },
    ["Registers"] = {
        { "show registers content",                   ":reg[isters]" },
        { "yank into register x",                     "\"xy" },
        { "paste contents of register x",             "\"xp" },
        { "yank into the system clipboard register",  "\"+y" },
        { "paste from the system clipboard register", "\"+p" },
    },
    ["Marks and positions"] = {
        { "list of marks",                           ":marks" },
        { "set current position for mark A",         "ma" },
        { "jump to position of mark A",              "`a" },
        { "yank text to position of mark A",         "y`a" },
        { "list of jumps",                           ":ju[mps]" },
        { "go to newer position in jump list",       "Ctrl + i" },
        { "go to older position in jump list",       "Ctrl + o" },
        { "list of changes",                         ":changes" },
        { "go to newer position in change list",     "g," },
        { "go to older position in change list",     "g;" },
        { "jump to the tag under cursor",            "Ctrl + ]" },
        { "go to the previously exit position",      "`0" },
        { "got to last edited line in file",         "`\"" },
        { "got to last changed position",            "`." },
        { "go to the position before the last jump", "``" },
    },
    ["Macros"] = {
        { "record macro a",       "qa" },
        { "stop recording macro", "q" },
        { "run macro a",          "@a" },
        { "rerun last run macro", "@@" },
    },
    ["Cut and paste"] = {
        { "yank a line",                            "yy" },
        { "yank 2 lines",                           "2yy" },
        { "yank word under the cursor",             "yiw" },
        { "yank to end of line",                    "y$ or Y" },
        { "paste the clipboard after cursor",       "p" },
        { "paste before cursor",                    "P" },
        { "cut a line",                             "dd" },
        { "cut 2 lines",                            "2dd" },
        { "cut word under the cursor",              "diw" },
        { "delete lines starting from 3 to 5",      ":3,5d" },
        { "cut to the end of the line",             "d$ or D" },
        { "cut character",                          "x" },
        { "delete all lines with pattern",          ":g/{pattern}/d" },
        { "delete all lines not with pattern",      ":g!/{pattern}/d" },
        { "yank word with whitespace",              "yaw" },
        { "paste clipboard after cursor and next",  "gp" },
        { "paste clipboard before cursor and next", "gP" },
        { "cut word with whitespace",               "daw" },
    },
    ["Indent text"] = {
        { "indent line one shiftwidth",       ">>" },
        { "de-indent line one shiftwidth",    "<<" },
        { "indent a block with () or {} ",    ">%" },
        { "de-indent a block with () or {} ", "<%" },
        { "indent inner block with ()",       ">ib" },
        { "indent a block with <> tags",      ">at" },
        { "re-indent 3 lines",                "3==" },
        { "re-indent a block with () or {} ", "=%" },
        { "re-indent inner block with {}",    "=iB" },
        { "re-indent entire buffer",          "gg=G" },
        { "paste while adjusting indent",     "]p" },
    },
    ["Exiting"] = {
        { "write",               ":w" },
        { "quit",                ":q" },
        { "write and quit",      ":wq or :x or ZZ" },
        { "quit without saving", ":q! or ZQ" },
        { "write all and quit",  ":wqa" },
    },
    ["Search and replace"] = {
        { "search for pattern",                    "/pattern" },
        { "search backward for pattern",           "?pattern" },
        { "repeat search in same direction",       "n" },
        { "repeat search in opposite direction",   "N" },
        { "replace all throughout file",           ":%s/old/new/g" },
        { "remove highlighting of search matches", ":noh[lsearch]" },
        { "replace all confirmations",             ":%s/old/new/gc" },
    },
    ["Search in multiple files"] = {
        { "jump to the next match",                       ":cn[ext]" },
        { "jump to the previous match",                   ":cp[revious]" },
        { "close the quickfix window",                    ":ccl[ose]" },
        { "open a window containing the list of matches", ":cope[n]" },
    },
    ["Tabs"] = {
        { "move to the next tab",                  "gt or :tabn[ext]" },
        { "move to the previous tab",              "gT or :tabp[revious]" },
        { "move to tab number #",                  "#gt" },
        { "open a file in a new tab",              ":tabnew" },
        { "close all tabs except for the current", ":tabo[nly]" },
        { "move split window into its own tab",    "Ctrl + wT" },
        { "move tab to the #th position ",         ":tabm[ove] #" },
        { "close the current tab",                 ":tabc[lose]" },
    },
    ["Working with multiple files"] = {
        { "edit a file in a new buffer",             ":e[dit] file" },
        { "go to the next buffer",                   ":bn[ext]" },
        { "go to the previous buffer",               ":bp[revious]" },
        { "delete a buffer (close a file)",          ":bd[elete]" },
        { "go to a buffer by index #",               ":b[uffer]#" },
        { "go to a buffer by file",                  ":b[uffer] file" },
        { "list all open buffers",                   ":ls or :buffers" },
        { "edit all buffers as tabs",                ":tab ba[ll]" },
        { "split window",                            "Ctrl + ws" },
        { "split window vertically",                 "Ctrl + wv" },
        { "switch windows",                          "Ctrl + ww" },
        { "quit a window",                           "Ctrl + wq" },
        { "open a file in new buffer and split ",    ":sp[lit] file" },
        { "edit all buffers as vertical windows",    ":vert[ical] ba[ll]" },
        { "file in new buffer, vertically split",    ":vs[plit] file" },
        { "exchange current window with next one",   "Ctrl + wx" },
        { "make all windows equal height & width",   "Ctrl + w=" },
        { "move cursor to the left window",          "Ctrl + wh" },
        { "move cursor to the right window",         "Ctrl + wl" },
        { "move cursor to the window below",         "Ctrl + wj" },
        { "move cursor to the window above",         "Ctrl + wk" },
        { "current window full height at far left",  "Ctrl + wH" },
        { "current window full height at far right", "Ctrl + wL" },
        { "current window full width at the bottom", "Ctrl + wJ" },
        { "current window full width at the top",    "Ctrl + wK" },
    },
    ["Diff"] = {
        { "manually define a fold up to motion",      "zf" },
        { "delete fold under the cursor",             "zd" },
        { "toggle fold under the cursor",             "za" },
        { "open fold under the cursor",               "zo" },
        { "close fold under the cursor",              "zc" },
        { "reduce (open) all folds by one level",     "zr" },
        { "fold more (close) all folds by one level", "zm" },
        { "toggle folding functionality",             "zi" },
        { "jump to start of next change",             "]c" },
        { "jump to start of previous change",         "[c" },
        { "obtain difference (from other buffer)",    "do or :diffg[et]" },
        { "put difference (to other buffer)",         "dp or :diffpu[t]" },
        { "make current window part of diff",         ":diffthis" },
        { "update differences",                       ":dif[fupdate]" },
        { "switch off diff mode for current window",  ":diffo[ff]" },
    },
}

excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens", "LuaSnip" }
-- code copied from, https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/cheatsheet/init.lua
local get_mappings = function(mappings, tb_to_add)
    for _, v in ipairs(mappings) do
        local desc = v.desc
        -- dont include mappings which have \n in their desc
        if not desc or (select(2, desc:gsub("%S+", "")) <= 1) or string.find(desc, "\n") then
            goto continue
        end
        local heading = desc:match "%S+" -- get first word
        heading = (v.mode ~= "n" and heading .. " (" .. v.mode .. ")") or heading
        -- useful for removing groups || <Plug> lhs keymaps from cheatsheet
        if
          vim.tbl_contains(excluded_groups, heading)
          or vim.tbl_contains(excluded_groups, desc:match "%S+")
          or string.find(v.lhs, "<Plug>")
        then
          goto continue
        end
        heading = heading
        if not tb_to_add[heading] then
            tb_to_add[heading] = {}
        end
        local keybind = string.sub(v.lhs, 1, 1) == " " and "<leader> +" .. v.lhs or v.lhs
        desc = v.desc:match "%s(.+)" -- remove first word from desc
        desc = desc
        table.insert(tb_to_add[heading], { desc, keybind })
        ::continue::
    end
end

local organize_mappings = function()
    local tb_to_add = {}
    local modes = { "n", "i", "v", "t" }
    for _, mode in ipairs(modes) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        local bufkeymaps = vim.api.nvim_buf_get_keymap(0, mode)
        get_mappings(keymaps, tb_to_add)
        get_mappings(bufkeymaps, tb_to_add)
    end
    -- remove groups which have only 1 mapping
    for key, x in pairs(tb_to_add) do
        if #x <= 1 then
            tb_to_add[key] = nil
        end
    end
    return tb_to_add
end
local maps = organize_mappings()

return {
    header = {
        [[  ______  __                           __           ______  __                           __]],
        [[ /      \|  \                         |  \         /      \|  \                         |  \]],
        [[ |  ▓▓▓▓▓▓\ ▓▓____   ______   ______  _| ▓▓_       |  ▓▓▓▓▓▓\ ▓▓____   ______   ______  _| ▓▓_]],
        [[ | ▓▓   \▓▓ ▓▓    \ /      \ |      \|   ▓▓ \      | ▓▓___\▓▓ ▓▓    \ /      \ /      \|   ▓▓ \]],
        [[ | ▓▓     | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\ \▓▓▓▓▓▓\\▓▓▓▓▓▓       \▓▓    \| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓▓▓▓▓]],
        [[ | ▓▓   __| ▓▓  | ▓▓ ▓▓    ▓▓/      ▓▓ | ▓▓ __      _\▓▓▓▓▓▓\ ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓    ▓▓ | ▓▓ __]],
        [[ | ▓▓__/  \ ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ | ▓▓|  \    |  \__| ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓▓ | ▓▓|  \]],
        [[  \▓▓    ▓▓ ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓  \▓▓  ▓▓     \▓▓    ▓▓ ▓▓  | ▓▓\▓▓     \\▓▓     \  \▓▓  ▓▓]],
        [[   \▓▓▓▓▓▓ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓   \▓▓▓▓       \▓▓▓▓▓▓ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓   \▓▓▓▓]],
        [[                                                                                                   ]],
        [[                                                                                                   ]],
        [[               Cheat Sheet scrapped from :https://vim.rtorr.com/                               ]],
        [[                                                                                                   ]],
    },
    keymaps = vim.tbl_deep_extend("force", maps, copiedMaps)
}
