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
            require("luasnip.loaders.from_vscode").lazy_load {
              paths = { vim.fn.stdpath "config" .. "/snippets" },
            }
          end,
        },
      },
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local path = require "completion.path"
    local compare = require "cmp.config.compare"
    luasnip.config.setup {}

    local function path_depth(entry)
      if not entry.source or entry.source.name ~= "path" then
        return nil
      end
      return select(2, (entry.completion_item.label or ""):gsub("/", ""))
    end

    -- Prefer files closer to the searched directory, then fall back to score.
    local function compare_path_depth(entry1, entry2)
      local depth1 = path_depth(entry1)
      local depth2 = path_depth(entry2)
      if depth1 and depth2 and depth1 ~= depth2 then
        return depth1 < depth2
      end
    end

    cmp.register_source("path", path.new())
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", background = "#333333" })

    local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"

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
          winhighlight = winhighlight,
        },
        documentation = cmp.config.window.bordered {
          border = "single",
          winhighlight = winhighlight,
        },
      },

      mapping = cmp.mapping.preset.insert {
        ["<A-i>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<A-y>"] = cmp.mapping.confirm { select = true },
        ["<A-p>"] = cmp.mapping.complete {},
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

        ["<C-n>"] = cmp.mapping(function()
          if not cmp.visible() then
            cmp.mapping.complete()()
          end
          cmp.select_next_item()
        end),
        ["<C-p>"] = cmp.mapping(function()
          if not cmp.visible() then
            cmp.mapping.complete()()
          end
          cmp.select_prev_item()
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
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
        { name = "crates" },
      },
      sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          compare_path_depth,
          compare.score,
          compare.recently_used,
          compare.locality,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
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
            path = kind_icons.Folder,
            crates = " ",
            codeium = require("utils.icons").others.ai .. "  ",
          })[entry.source.name]
          return vim_item
        end,
      },
    }

    -- cmp skips source updates when the cursor moves backwards, so a backspace
    -- leaves the previous path entries in the menu. Re-query while still in a
    -- path, and close the menu once the path prefix is gone.
    local last = { buf = -1, line = -1, col = -1 }
    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
      callback = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local buf, line, col = vim.api.nvim_get_current_buf(), cursor[1], cursor[2]
        local backward = last.buf == buf and last.line == line and col < last.col
        last.buf, last.line, last.col = buf, line, col
        if not backward then
          return
        end

        -- Scheduled so cmp does not run its own waits inside the text change.
        vim.schedule(function()
          if not cmp.visible() then
            return
          end
          local has_path = false
          for _, entry in ipairs(cmp.get_entries()) do
            if entry.source and entry.source.name == "path" then
              has_path = true
              break
            end
          end
          if not has_path then
            return
          end

          local now = vim.api.nvim_win_get_cursor(0)
          local before = vim.api.nvim_get_current_line():sub(1, now[2])
          if path.has_path_context(before) then
            cmp.complete()
          else
            cmp.abort()
          end
        end)
      end,
    })
  end,
}
