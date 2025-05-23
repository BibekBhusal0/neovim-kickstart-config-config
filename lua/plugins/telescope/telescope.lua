local map = require "utils.map"

local findInLazy = function()
  require("telescope.builtin").find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end

local findInConfig = function()
  require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
end

local findInCurrentBufferDir = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    require("telescope.builtin").find_files { cwd = vim.fn.getcwd() }
  else
    require("telescope.builtin").find_files { cwd = vim.fn.fnamemodify(current_file, ":h") }
  end
end

local live_multigrep = function(opts)
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"
  local conf = require("telescope.config").values
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end
      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end
      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

local findOpenFiles =
  ":Telescope live_grep theme=dropdown grep_open_files=true prompt_title=Search<CR>"

map("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", "Find in current buffer")
map("<leader>:", ":Telescope command_history<CR>", "Find Commands history")
map("<leader>I", ":Telescope spell_suggest<CR>", "Spell suggestion")
map("<leader>f.", ":Telescope oldfiles<CR>", "Find recent Files")
map("<leader>f/", findOpenFiles, "Find in Open Files")
map("<leader>f:", ":Telescope commands<CR>", "Find Commands")
map("<leader>fA", ":Telescope autocommands<CR>", "Find Autocommands")
map("<leader>fb", ":Telescope buffers<CR>", "Find buffers in current tab")
map("<leader>fB", ":Telescope scope buffers layout_strategy=vertical<CR>", "Find All Buffers ")
map("<leader>fC", findInConfig, "Find All Neovim Config")
map("<leader>fd", ":Telescope diagnostics<CR>", "Find Diagnostics")
map("<leader>ff", ":Telescope find_files<CR>", "Find Files")
map("<leader>fg/", ":Telescope git_stash<CR>", "Find Git Stash")
map("<leader>fgb", ":Telescope git_branches<CR>", "Find Git Branches")
map("<leader>fgC", ":Telescope git_bcommits<CR>", "Find Git Commits of current buffer")
map("<leader>fgc", ":Telescope git_commits<CR>", "Find Git Commits")
map("<leader>fgf", ":Telescope git_files<CR>", "Find Git Files")
map("<leader>fgm", ":Telescope marks mark_type=gloabl<CR>", "Find marks global")
map("<leader>fgs", ":Telescope git_status<CR>", "Find Git Status")
map("<leader>fgw", live_multigrep, "Find Multi Grep")
map("<leader>fh", ":Telescope harpoon marks layout_strategy=vertical<CR>", "Find Harpoon Marks")
map("<leader>fH", ":Telescope help_tags<CR>", "Find Help Tags")
map("<leader>fj", findInCurrentBufferDir, "Telescope Find in current buffer directory")
map("<leader>fk", ":Telescope keymaps<CR>", "Find Keymaps")
map("<leader>fL", findInLazy, "Find Lazy Plugins Files")
map("<leader>fM", ":Telescope marks mark_type=all<CR>", "Find marks all")
map("<leader>fm", ":Telescope marks mark_type=local<CR>", "Find marks")
map("<leader>fq", ":Telescope quickfix<CR>", "Find Quickfix list")
map("<leader>fr", ":Telescope resume<CR>", "Find Resume")
map("<leader>fs", ":Telescope builtin<CR>", "Find Telescope")
map("<leader>fT", ":Telescope treesitter<CR>", "Find Treesitter")
map("<leader>fv", ":Telescope vim_options<CR>", "Find Files in split")
map("<leader>fW", ":Telescope grep_string<CR>", "Find current Word")
map("<leader>fw", ":Telescope live_grep<CR>", "Find by Grep")
map("<leader>fy", ":Telescope registers<CR>", "Find registers")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
          override = {
            deb = { icon = "", name = "Deb" },
            lock = { icon = "󰌾", name = "Lock" },
            mp3 = { icon = "󰎆", name = "Mp3" },
            mp4 = { icon = "", name = "Mp4" },
            ["robots.txt"] = { icon = "󰚩", name = "Robots" },
            ttf = { icon = "", name = "TrueTypeFont" },
            rpm = { icon = "", name = "Rpm" },
            woff = { icon = "", name = "WebOpenFontFormat" },
            woff2 = { icon = "", name = "WebOpenFontFormat2" },
            xz = { icon = "", name = "Xz" },
            zip = { icon = "", name = "Zip" },
          },
        },
      },
      "prochri/telescope-all-recent.nvim",
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-ui-select.nvim",
    },

    config = require "plugins.telescope.config",
  },
}
