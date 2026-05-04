local wrap_keys = require "utils.wrap_keys"

local command = vim.api.nvim_create_user_command
command("Qs", function()
  require("resession").save("auto-session", { notify = false })
  vim.cmd "qa!"
end, {})

command("Load", function()
  require("resession").load("auto-session", { silence_errors = true })
end, {})

command("SessionSave", function(opts)
  if opts.args ~= "" then
    require("resession").save(opts.args, { notify = true })
  else
    require("resession").save(nil, { notify = true })
  end
end, { nargs = "?" })

command("SessionLoad", function(opts)
  if opts.args ~= "" then
    require("resession").load(opts.args, { attach = true, silence_errors = false })
  else
    require("resession").load(nil, { attach = true, silence_errors = false })
  end
end, { nargs = "?" })

command("SessionSaveTab", function(opts)
  if opts.args ~= "" then
    require("resession").save_tab(opts.args, { notify = true })
  else
    require("resession").save_tab(nil, { notify = true })
  end
end, { nargs = "?" })

command("SessionDelete", function(opts)
  if opts.args ~= "" then
    require("resession").delete(opts.args, { notify = true })
  else
    require("resession").delete(nil, { notify = true })
  end
end, { nargs = "?" })

vim.cmd "cnoreabbrev <expr> qs ((getcmdtype() == ':' && getcmdline() ==# 'qs') ? 'Qs' : 'qs')"
vim.cmd "cnoreabbrev <expr> load ((getcmdtype() == ':' && getcmdline() ==# 'load') ? 'Load' : 'load')"

return {
  "stevearc/resession.nvim",
  keys = wrap_keys {
    { "<leader>sz", ":SessionDelete<CR>", desc = "Session Delete" },
    { "<leader>sl", ":SessionLoad<CR>", desc = "Session Load" },
    { "<leader>ss", ":SessionSave<CR>", desc = "Session Save" },
    { "<leader>sS", ":SessionSaveTab<CR>", desc = "Session Save Tab" },
  },
  opts = {
    buf_filter = function(bufnr)
      local buftype = vim.bo.buftype
      if buftype == "help" then
        return true
      end
      if buftype ~= "" and buftype ~= "acwrite" then
        return false
      end
      if vim.api.nvim_buf_get_name(bufnr) == "" then
        return false
      end
      return true
    end,
    extensions = {
      scope = {},
      cd = {},
      tabname = {},
      bufstack = {},
    },
  },
}
