# Neovim Configuration - Agent Guidelines

## Build, Lint, and Format Commands

This is a Neovim Lua configuration. No build process required.

**Format:**
```bash
# Format all Lua files
stylua .

# Format specific file
stylua lua/plugins/your-file.lua
```

**Lint:**
- No explicit linting configured beyond Neovim's built-in Lua LSP (lua_ls)
- Use `:lua vim.lsp.buf.format()` in Neovim to format on save

**Test:**
- No test framework for the config itself
- For testing project code, use neotest keybindings:
  - `<leader>Tr` - Run nearest test
  - `<leader>TR` - Run all tests in current file
  - `<leader>Td` - Debug test with DAP

## Code Style Guidelines

### Formatting
- Indentation: 2 spaces (configured in `.stylua.toml`)
- Max line width: 100 characters
- Quote style: Double quotes preferred (auto)
- No parentheses around single-string requires: `require "module"`

### Imports and Requires
```lua
-- At the top of files, require local utilities first
local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"
local icons = require "utils.icons"

-- Then require plugin modules if needed
```

### File Structure
- Plugin configurations in `lua/plugins/`
- Use subdirectories for categorization (e.g., `lua/plugins/telescope/`, `lua/plugins/ai/`)
- Core settings in `lua/core/`
- Utilities in `lua/utils/`

### Naming Conventions
- Files: lowercase with hyphens (e.g., `telescope.lua`, `windowManagemet.lua`)
- Local variables: `snake_case`
- Functions: `snake_case`
- Modules: lowercase with dots (e.g., `utils.map`, `plugins.lsp`)

### Plugin Configuration Pattern
```lua
local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

return {
  {
    "author/plugin-name",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "dependency/plugin",
    },
    keys = wrap_keys {
      { "<leader>key", ":Command<CR>", desc = "Description" },
    },
    config = function()
      require "plugin-name".setup {
        -- configuration options
      }
    end,
  },
}
```

### Keymap Conventions
- Use `map()` utility from `utils.map` for keymaps
- Leader key is Space (`<leader>`)
- Use descriptive names in keymap descriptions
- Wrap key bindings with `wrap_keys()` to set `silent = true`
- Example: `map("<leader>ff", ":Telescope find_files<CR>", "Find Files")`

### Code Patterns
- Define local functions before use
- Return tables for module exports
- Use vim.api.nvim functions for Neovim API calls
- Use table literals `{}` instead of `table.new()`
- Plugin configs are tables returned from files

### Error Handling
- Use simple if statements for nil checks
- Return early on error conditions
- Example:
```lua
local client = vim.lsp.get_client_by_id(event.data.client_id)
if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
  -- code
end
```

### Comments
- Use `--` for single-line comments
- Keep comments concise
- Comment keymap purposes and plugin sections
- No trailing comments on simple assignments

### LSP Server Configuration
- Servers configured in `lua/plugins/lsp.lua`
- Use `vim.lsp.config()` and `vim.lsp.enable()` (Neovim 0.10+)
- Extend capabilities using `vim.tbl_deep_extend("force", ...)`
- Common servers: lua_ls, ts_ls, ruff, pylsp, html, cssls, tailwindcss, jsonls

### Autocommands
- Use `vim.api.nvim_create_autocmd()`
- Create augroups with `vim.api.nvim_create_augroup()`
- Use autocmds for formatting, highlights, and buffer-specific settings
