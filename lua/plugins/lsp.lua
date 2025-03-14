local map = require 'utils.map'

vim.g.lsp_autostart = true
map('<leader>Lt', function()
  vim.g.lsp_autostart = true
  vim.cmd.LspStart()
end, 'LSP Start')

map('<leader>LT', function()
  vim.g.lsp_autostart = false
  vim.cmd.LspStop()
end, 'LSP Stop')

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          map('<leader>ld', require('telescope.builtin').lsp_definitions, 'LSP goto Definition')
          map('<leader>lr', require('telescope.builtin').lsp_references, 'LSP goto References')
          map('<leader>li', require('telescope.builtin').lsp_implementations, 'LSP Goto Implementation')
          map('<leader>ls', require('telescope.builtin').lsp_type_definitions, 'LSP Type Definition')
          map('<leader>la', require('telescope.builtin').lsp_document_symbols, 'LSP Document Symbols')
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'LSP Workspace Symbols')

          local rename = function()
            local var = vim.fn.expand '<cword>'
            local callback = function(text)
              local params = vim.lsp.util.make_position_params()
              params.newName = text
              vim.lsp.buf_request(0, 'textDocument/rename', params)
            end
            require 'utils.input'(' Rename ', callback, var, nil, require('utils.icons').symbols.Variable)
          end
          map('<leader>ln', rename, 'LSP Rename variable')

          local function code_action()
            pcall(require('telescope').load_extension, 'ui-select')
            vim.lsp.buf.code_action()
          end
          map('<leader>ca', code_action, 'LSP code action', { 'n', 'x' })

          map('<leader>lD', vim.lsp.buf.declaration, 'LSP goto Declaration')
          map('<leader>lh', vim.lsp.buf.hover, 'LSP Hover')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lH', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'LSP Toggle Inlay Hints')
          end
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
        group = vim.api.nvim_create_augroup('lsp_autostart', { clear = true }),
        callback = function()
          if vim.g.lsp_autostart then
            vim.schedule(vim.cmd.LspStart)
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        ts_ls = {}, -- tsserver is deprecated
        ruff = {},
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
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},
        tailwindcss = {},
        -- terraformls = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              format = { enable = false },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.autostart = false
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- setting up emmit  https://github.com/aca/emmet-ls
      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.emmet_ls.setup {
        -- on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'svelte', 'pug', 'typescriptreact', 'vue' },
      }
    end,
  },

  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    keys = { { '<leader>lm', ":lua require('nvim-navbuddy').open()<CR>", desc = 'Open Navbuddy' } },
    config = function()
      local navbuddy = require 'nvim-navbuddy'
      local icons = require('utils.icons').get_padded_icon 'symbols'
      navbuddy.setup {
        lsp = { auto_attach = true },
        icons = icons,
      }
    end,
  },
}
