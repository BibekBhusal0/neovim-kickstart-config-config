local kind_icons = require("utils.icons").symbols

-- Source: https://www.reddit.com/r/neovim/comments/1g68lsy/easiest_way_to_add_tailwindcss_support_for/
local format_tailwind = function(entry, item)
  local entryItem = entry:get_completion_item()
  local color = entryItem.documentation

  -- check if color is hexcolor
  if color and type(color) == "string" and color:match "^#%x%x%x%x%x%x$" then
    local hl = "hex-" .. color:sub(2)

    if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
      vim.api.nvim_set_hl(0, hl, { fg = color })
    end

    item.kind = " "
    item.kind_hl_group = hl
  end

  return item
end

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
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    luasnip.config.setup {}

    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", background = "#333333" })

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
        completion = cmp.config.window.bordered {
          border = "single",
          winhighlight = winhighlight.winhighlight,
        },
        documentation = cmp.config.window.bordered {
          border = "single",
          winhighlight = winhighlight.winhighlight,
        },
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
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item = format_tailwind(entry, vim_item)
          vim_item.menu = ({
            luasnip = " ",
            nvim_lsp = " ",
            buffer = " ",
            path = " ",
            codeium = require("utils.icons").others.ai .. "  ",
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
