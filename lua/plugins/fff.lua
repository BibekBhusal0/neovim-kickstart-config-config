local wrap_keys = require "utils.wrap_keys"

local findInLazy = function()
  require("fff").find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end
local findInConfig = function()
  require("fff").find_files { cwd = vim.fn.stdpath "config" }
end
local findInCurrentBufferDir = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    require("fff").find_files { cwd = vim.fn.getcwd() }
  else
    require("fff").find_files { cwd = vim.fn.fnamemodify(current_file, ":h") }
  end
end

return {
  "dmtrKovalenko/fff.nvim",
  dependencies = { { "folke/snacks.nvim", lazy = true } },
  build = function()
    require("fff.download").download_or_build_binary()
  end,

  opts = {
    prompt = "> ",
    prompt_vim_mode = true,
    keymaps = { move_up = { "<C-k>" }, move_down = { "<C-j>" } },
    git = { status_text_color = true },
    debug = { enabled = false, show_scores = false },
  },
  config = function(_, opts)
    require("fff").setup(opts)

    local ok_ui, picker_ui = pcall(require, "fff.picker_ui.picker_ui")
    local ok_state, picker_state = pcall(require, "fff.picker_ui.picker_ui_state")
    if not ok_ui or not ok_state then
      return
    end

    local orig_select = picker_ui.select
    picker_ui.select = function(action)
      local paths = {}
      if action == nil or action == "edit" then
        local ok, entries = pcall(picker_state.get_selected_file_entries)
        if ok and entries then
          for _, entry in ipairs(entries) do
            table.insert(paths, entry.edit_path)
          end
        end
      end

      orig_select(action)

      if #paths > 0 then
        vim.schedule(function()
          for _, path in ipairs(paths) do
            local bufnr = vim.fn.bufnr(path)
            if bufnr ~= -1 and not vim.api.nvim_buf_is_loaded(bufnr) then
              pcall(vim.fn.bufload, bufnr)
            end
          end
        end)
      end
    end
  end,
  keys = wrap_keys {
    { "<Leader>ff", ":lua require('fff').find_files()<CR>", desc = "Find files" },
    { "<Leader>fw", ":lua require('fff').live_grep()<Cr>", desc = "Live grep" },
    {
      "<Leader>fG",
      ":lua require('fff').live_grep({grep={modes={'fuzzy','plain'}}})<cr>",
      desc = "Live grep (fuzzy)",
    },
    {
      "<Leader>fW",
      ":lua require('fff').live_grep { query = vim.fn.expand '<cword>' }<Cr>",
      desc = "Find current word",
    },
    { "<Leader>fj", findInCurrentBufferDir, desc = "Find files in current buffer directory" },
    { "<Leader>fC", findInConfig, desc = "Find Files in config directory" },
    { "<Leader>fL", findInLazy, desc = "Find Files in Lazy directory" },
  },
}
