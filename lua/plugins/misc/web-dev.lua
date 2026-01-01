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
    "luckasRanarison/tailwind-tools.nvim",
    enabled =false,
    build = ":UpdateRemotePlugins",
    ft = webDev,
    config = function()
      require("tailwind-tools").setup {
        document_color = { enabled = true },
        conceal = { enabled = true, symbol = "…" },
        server = { settings = { experimental = { classRegex = patterns } } },
      }
      map("<leader>ft", ":Telescope tailwind classes<CR>", "Find Tailwind Classes")
      map("<leader>tc", ":TailwindColorToggle<CR>", "Tailwind Color Toggle")
      map("<leader>tf", ":TailwindConcealToggle<CR>", "Tailwind Fold Toggle")
      map("<leader>ts", ":TailwindSort<CR>", "Tailwind search")
      map("<leader>]t", ":TailwindNextClass<CR>", "Jump Next Tailwind Cllass")
      map("<leader>[t", ":TailwindPrevClass<CR>", "Jump Prev Tailwind Cllass")
    end,
  }, -- tailwind color highlights folds and more

  {
    "windwp/nvim-ts-autotag",
    opts = {},
    ft = webDev,
  }, -- Autoclose HTML tags

  {
    "TiagoMDG/react-comp-gen.nvim",
    cmd = { "CreateComponent" },
    keys = wrap_keys {
      {
        "<leader>CC",
        function()
          require "utils.input"("Name", function(text)
            vim.cmd("CreateComponent " .. text)
          end, "", 20, "󰜈 ")
        end,
        desc = "Add component",
      },
    },
    opts = { defult_path = "/src/components/", generate_css_file = false },
  },

  {
    "mawkler/jsx-element.nvim",
    ft = { "typescriptreact", "javascriptreact", "javascript" },
  },
}
