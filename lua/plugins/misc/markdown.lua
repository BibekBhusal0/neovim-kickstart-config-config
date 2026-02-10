local map = require "utils.map"

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
      to_do = { status_propagation = { up = true } },
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
}
