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
        file_type = { "markdown", "codecompanion", "vimwiki" },
        sign = { enabled = false },
        link = {
          custom = {
            wikipedia = { pattern = "wikiwand%.org", icon = "󰖬 " },
            twitter = { pattern = "twitter%.com", icon = " " },
            header = { pattern = "^#.+", icon = "# " },
            linkedin = { pattern = "linkedin%.com", icon = " " },
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
    config = function()
      require("mkdnflow").setup {
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
      }
    end,
  }, -- Better editing in markdown
}
