local kind_icons = require("utils.icons").symbols

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    "dnnr1/lorem-ipsum.nvim",
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-calc",
    -- "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    luasnip.config.setup {}

    local winhighlight = {
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      window = {
        completion = cmp.config.window.bordered(winhighlight),
        documentation = cmp.config.window.bordered(winhighlight),
      },

      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-i>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<a-y>"] = cmp.mapping.confirm { select = true },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<A-b>"] = cmp.mapping.complete {},
        ["<C-S-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-S-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<A-o>"] = cmp.mapping(function()
          if not cmp.visible_docs() then
            cmp.open_docs()
          else
            cmp.close_docs()
          end
        end),

        -- For more advanced LuaSnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        -- Select next/previous item with Tab / Shift + Tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },

      sources = {
        { name = "codeium" },
        { name = "nvim_lsp" },
        { name = "lazydev", group_index = 0 },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "lorem_ipsum" },
        -- { name = "emoji" },
        -- { name = "calc" },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local webDev =
            { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" }
          local filetype = vim.bo.filetype
          local is_webdev_file = vim.tbl_contains(webDev, filetype)
          if is_webdev_file then
            local status, lspkind_format = pcall(require, "tailwind-tools.cmp")
            if status then
              vim_item = lspkind_format(entry, vim_item)
            end
          end

          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({
            luasnip = " ",
            nvim_lsp = " ",
            buffer = " ",
            path = " ",
            emoji = "",
            lorem_ipsum = "󰎞 ",
            calc = " ",
            codeium = require("utils.icons").others.ai .. "  ",
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
