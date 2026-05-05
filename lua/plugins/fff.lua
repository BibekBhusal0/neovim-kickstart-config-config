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
  build = function()
    require("fff.download").download_or_build_binary()
  end,

  opts = {
    prompt = "> ",
    prompt_vim_mode = true,
    keymaps = { move_up = { "<C-k>" }, move_down = { "<C-j>" } },
    git = { status_text_color = true },
    debug = { enabled = false, show_scores = true },
  },
  keys = {
    { "<Leader>ff", ":lua require('fff').find_files()<CR>", desc = "Find files" },
    { "<Leader>fw", ":lua require('fff').live_grep()<Cr>", desc = "Live grep" },
    {
      "<Leader>fW",
      ":lua require('fff').live_grep { query = vim.fn.expand '<cword>' }<Cr>",
      desc = "Find current word",
    },
    { "<Leader>fj", findInCurrentBufferDir, "Find files in current buffer directory" },
    { "<Leader>fC", findInConfig, "Find Files in config directory" },
    { "<Leader>fL", findInLazy, "Find Files in Lazy directory" },
  },
}
