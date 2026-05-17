local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"
local obsidian_dir = "~/Documents/vault"

return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "vimwiki" },
    config = function()
      require("render-markdown").setup {
        file_type = { "markdown", "codecompanion", "vimwiki", "Avante" },
        sign = { enabled = false },
        link = {
          custom = {
            wikipedia = { pattern = "wikiwand%.org", icon = "󰖬 " },
            twitter = { pattern = "twitter%.com", icon = " " },
            header = { pattern = "^#.+", icon = "# " },
            linkedin = { pattern = "linkedin%.com", icon = " " },
          },
        },
        checkbox = {
          custom = {
            canceled = {
              raw = "[-]",
              rendered = "--",
              highlight = "Comment",
              scope_highlight = nil,
            },
            incomplete = { raw = "[/]", rendered = "󱎖 ", highlight = "RenderMarkdownTodo" },
            forwarded = { raw = "[>]", rendered = " ", highlight = "Comment" },
            scheduling = { raw = "[<]", rendered = " ", highlight = "Comment" },
            question = { raw = "[?]", rendered = " " },
            important = { raw = "[!]", rendered = " ", highlight = "javaScriptFunction" },
            star = { raw = "[*]", rendered = " ", highlight = "javaScriptFunction" },
            quote = { raw = '["]', rendered = " ", highlight = "function" },
            location = { raw = "[l]", rendered = " ", highlight = "boolean" },
            bookmark = { raw = "[b]", rendered = " ", highlight = "javaScriptFunction" },
            information = { raw = "[i]", rendered = "󰋼 ", highlight = "function" },
            idea = { raw = "[I]", rendered = " ", highlight = "javaScriptFunction" },
            pros = { raw = "[p]", rendered = " ", highlight = "function" },
            cons = { raw = "[c]", rendered = " ", highlight = "javaScriptFunction" },
            fire = { raw = "[f]", rendered = " ", highlight = "boolean" },
            key = { raw = "[k]", rendered = " " },
            up = { raw = "[u]", rendered = "󰔵 ", highlight = "function" },
            down = { raw = "[d]", rendered = "󰔳 ", highlight = "boolean" },
          },
        },
      }
      map("<leader>mm", ":RenderMarkdown toggle<CR>", "Markdown Render Toggle")
      map("<leader>mM", ":RenderMarkdown buf_toggle<CR>", "Markdown Render Buffer Toggle")
    end,
  }, -- better markdown render

  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    config = {
      filetypes = { rmd = true, markdown = true },
      to_do = {
        highlight = false,
        sort = { on_status_change = false, recursive = false, cursor_behavior = { track = true } },
      },
      mappings = {
        MkdnEnter = { { "i" }, "<CR>" },
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = { "n", "]l" },
        MkdnPrevLink = { "n", "[l" },
        MkdnNextHeading = { "n", "]h" },
        MkdnPrevHeading = { "n", "[h" },
        MkdnGoBack = { "n", "<BS>" },
        MkdnGoForward = { "n", "<Del>" },
        MkdnCreateLink = false,
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<A-p>" },
        MkdnFollowLink = false,
        MkdnDestroyLink = { "n", "<M-CR>" },
        MkdnTagSpan = { "v", "<M-CR>" },
        MkdnMoveSource = { "n", "<F2>" },
        MkdnYankAnchorLink = { "n", "yaa" },
        MkdnYankFileAnchorLink = { "n", "yfa" },
        MkdnIncreaseHeading = { "n", "+" },
        MkdnDecreaseHeading = { "n", "-" },
        MkdnToggleToDo = { { "n", "i" }, "<C-q>" },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = { "n", "o" },
        MkdnNewListItemAboveInsert = { "n", "O" },
        MkdnExtendList = false,
        MkdnUpdateNumbering = { "n", "<leader>nN" },
        MkdnTableNextCell = { "i", "]C" },
        MkdnTablePrevCell = { "i", "[C" },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { "i", "<M-CR>" },
        MkdnTableNewRowBelow = { "n", "Zr" },
        MkdnTableNewRowAbove = { "n", "ZR" },
        MkdnTableNewColAfter = { "n", "Zc" },
        MkdnTableNewColBefore = { "n", "ZC" },
        MkdnFoldSection = { "n", "<leader>zO" },
        MkdnUnfoldSection = { "n", "<leader>zo" },
      },
      foldtext = { object_count_icon_set = "nerdfont" },
    },
  }, -- Better editing in markdown

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    keys = wrap_keys {
      { "<leader>nD", ":Obsidian dailies<CR>", desc = "Obsidian Dailies" },
      { "<leader>nd", ":Obsidian today<CR>", desc = "Obsidian Today" },
      { "<leader>nj", ":Obsidian yesterday<CR>", desc = "Obsidian Yesterday" },
      { "<leader>no", ":Obsidian new<CR>", desc = "Obsidian New" },
      { "<leader>nO", ":Obsidian new_from_template<CR>", desc = "Obsidian New with Tempalte" },
      { "<leader>nf", ":Obsidian quick_switch<CR>", desc = "Obsidian Find Notes" },
      { "<leader>fn", ":Obsidian quick_switch<CR>", desc = "Obsidian Find Notes" },
      { "<leader>ns", ":Obsidian search<CR>", desc = "Obsidian Search" },
      { "<leader>nT", ":Obsidian tags<CR>", desc = "Obsidian Tags" },
      { "<leader>nt", ":Obsidian template<CR>", desc = "Obsidian Insert template" },
    },
    cmd = { "Obsidian" },
    event = {
      "BufReadPre " .. obsidian_dir .. "/*.md",
      "BufNewFile " .. obsidian_dir .. "/*.md",
    },
    opts = {
      workspaces = { { name = "main", path = obsidian_dir } },
      legacy_commands = false,
      log_level = vim.log.levels.INFO,
      templates = {
        folder = "templates/main",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      daily_notes = {
        folder = "1 raw/Daily",
        date_format = "%Y/%m/%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-note" },
        template = "daily",
      },
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<A-n>",
          insert_link = "<A-i>",
        },
        tag_mappings = {
          tab_note = "<A-n>",
          insert_tag = "<A-i>",
        },
      },
      ui = { enable = false },
      attachments = {
        folder = "files",
        img_name_func = function()
          return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
        end,
        confirm_img_paste = true,
      },
      note_id_func = function(title)
        if title and title ~= "" then
          return title
        else
          return tostring(os.time())
        end
      end,
      callbacks = {
        enter_note = function(note)
          if not note then return end
          vim.keymap.set("n", "gF", ":Obsidian follow_link vsplit<cr>", {
            buffer = note.bufnr,
            desc = "Follow link vertical split",
          })
          vim.keymap.set("n", "gf", ":Obsidian follow_link<cr>", {
            buffer = note.bufnr,
            desc = "Follow link ",
          })
          vim.keymap.set("n", "<leader>nb", ":Obsidian backlinks<cr>", {
            buffer = note.bufnr,
            desc = "Backlinks",
          })
          vim.keymap.set("n", "<leader>nc", ":Obsidian toc<cr>", {
            buffer = note.bufnr,
            desc = "Table of Content",
          })
          vim.keymap.set("n", "<leader>nl", ":Obsidian links<cr>", {
            buffer = note.bufnr,
            desc = "Links",
          })
          vim.keymap.set("v", "<leader>ne", ":Obsidian extract_note<cr>", {
            buffer = note.bufnr,
            desc = "Extract note",
          })
        end,
      },
    },
  },
}
