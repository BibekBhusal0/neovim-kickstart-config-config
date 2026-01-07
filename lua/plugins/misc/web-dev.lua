local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"
local webDev =
  { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" }
local patterns = {
  "tw`([^`]*)",
  'tw="([^"]*)',
  'tw={"([^"}]*)',
  "tw\\.\\w+`([^`]*)",
  "tw\\(.*?\\)`([^`]*)",
  { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
  { "classnames\\(([^)]*)\\)", "'([^']*)'" },
  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
  { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
}

return {
  {
    "BibekBhusal0/nvim-shadcn",
    opts = {
      format = { solid = "npx shadcn-solid@latest add %s" },
      keys = {
        n = { solid = "<C-s>" },
        i = { solid = "<C-s>" },
      },
      init_command = { default_color = "Zinc" },
    },
    cmd = { "ShadcnAdd", "ShadcnInit", "ShadcnAddImportant" },
    keys = wrap_keys {
      { "<leader>sa", ":ShadcnAdd<CR>", desc = "Add shadcn component" },
    },
  },

  {
    "razak17/tailwind-fold.nvim",
    event = "VeryLazy",
    ft = webDev,
    config = function()
      require("tailwind-fold").setup {
        enabled = true,
        symbol = "…", -- 󱏿
        ft = webDev,
      }
      map("<leader>tf", ":TailwindFoldToggle<CR>", "Tailwind Fold Toggle")
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    opts = {},
    ft = webDev,
  }, -- Autoclose HTML tags

  {
    "mawkler/jsx-element.nvim",
    ft = { "typescriptreact", "javascriptreact", "javascript" },
  },
}
