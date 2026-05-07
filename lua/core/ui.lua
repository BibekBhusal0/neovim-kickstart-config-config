-- Appearance of diagnostics
vim.diagnostic.config {
  float = {
    border = "rounded",
    source = "if_many",
    focusable = true,
    severity_sort = true,
    header = "",
  },
}

-- Experimental UI2: floating cmdline and messages
require("vim._core.ui2").enable {
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "msg",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "msg",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "pager",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    msg = { height = 0.3, timeout = 1000 },
    pager = { height = 0.5 },
  },
}

local ui2 = require "vim._core.ui2"
local msgs = require "vim._core.ui2.messages"
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
  orig_set_pos(tgt)
  if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
    pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
      relative = "editor",
      anchor = "NE",
      row = vim.o.lines - 2,
      col = vim.o.columns - 2,
      border = "rounded",
    })
  end
end
