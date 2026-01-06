local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", config = true, cmd = "Mason" },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          map("<leader>la", ":Telescope lsp_document_symbols<CR>", "LSP Document Symbols")
          map("<leader>ld", ":Telescope lsp_definitions<CR>", "LSP goto Definition")
          map(
            "<leader>le",
            ":Telescope lsp_definitions jump_type=vsplit<CR>",
            "LSP goto Definition In Split"
          )
          map("<leader>li", ":Telescope lsp_implementations<CR>", "LSP Goto Implementation")
          map("<leader>lr", ":Telescope lsp_references<CR>", "LSP goto References")
          map("<leader>ls", ":Telescope lsp_type_definitions<CR>", "LSP Type Definition")
          map(
            "<leader>lS",
            ":Telescope lsp_type_definitions jump_type=vsplit<CR>",
            "LSP Type Definition In Split"
          )
          map("<leader>lw", ":Telescope lsp_dynamic_workspace_symbols<CR>", "LSP Workspace Symbols")

          -- local rename = function()
          --   local var = vim.fn.expand "<cword>"
          --   local callback = function(text)
          --     local params = vim.lsp.util.make_position_params()
          --     params.newName = text
          --     vim.lsp.buf_request(0, "textDocument/rename", params)
          --   end
          --   require "utils.input"(
          --     " Rename ",
          --     callback,
          --     var,
          --     nil,
          --     require("utils.icons").symbols.Variable .. "  "
          --   )
          -- end
          -- map("<leader>ln", rename, "LSP Rename variable")
          map("<leader>ln", vim.lsp.buf.rename, "Lsp Rename variable")
          map("<leader>ca", function()
            require "telescope"
            vim.lsp.buf.code_action()
          end, "LSP code action", { "n", "x" })

          map("<leader>lD", vim.lsp.buf.declaration, "LSP goto Declaration")
          map("<leader>lh", vim.lsp.buf.hover, "LSP Hover")

          -- The following two autoCommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autoCommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
          then
            local highlight_augroup =
              vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keyMap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>lH", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "LSP Toggle Inlay Hints")
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luaSnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("cmp_nvim_lsp").default_capabilities(),
        require("lsp-file-operations").default_capabilities()
      )

      local servers = {
        ts_ls = { format = { enable = false } },
        ruff = { format = { enable = false } },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                mccabe = { enabled = false },
                pylsp_mypy = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_isort = { enabled = false },
              },
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "svelte",
            "pug",
            "typescriptreact",
            "vue",
          },
        },
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = { format = { enable = false } },
          },
        },
        bashls = { filetypes = { "sh", "zsh" } }
      }
      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {})
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for server, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end
    end,
  },

  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    keys = wrap_keys {
      { "<leader>lm", ":lua require('nvim-navbuddy').open()<CR>", desc = "Open Navbuddy" },
    },
    config = function()
      local navbuddy = require "nvim-navbuddy"
      local icons = require("utils.icons").get_padded_icon "symbols"
      navbuddy.setup {
        lsp = { auto_attach = true },
        icons = icons,
      }
    end,
  }, -- Easy navigation within lsp Symbols

  {
    "Zeioth/garbage-day.nvim",
    event = "LspAttach",
    opts = {},
  }, -- Free up resources by stooping unused LSP clients

  {
    "antosha417/nvim-lsp-file-operations",
    lazy = true,
  },

  {
    "rachartier/tiny-code-action.nvim",
    enabled = false,
    config = function()
      local code_action = require "tiny-code-action"
      code_action.config.picker.opts.layout_config.preview_height = nil
      code_action.setup {
        picker = {
          picker = "telescope",
          opts = require("telescope.themes").get_cursor {
            default_index = 1,
            initial_mode = "normal",
            -- layout_config = { width = 60, height = 15, preview_cutoff = 200 }, -- only way to disable preview
            layout_config = { width = 90, height = 15, preview_width = 30 }, -- this is also fine i guess
          },
        },
      }
    end,
    keys = wrap_keys {
      {
        "<leader>ca",
        ':lua require("tiny-code-action").code_action()<CR>',
        desc = "LSP code actions",
      },
    },
  },

  {
    "folke/lazydev.nvim",
    enabled = true,
    ft = "lua",
    opts = {
      library = {},
    },
  },
}
