local wrap_keys = require "utils.wrap_keys"

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })

return {
  "stevearc/conform.nvim",
  dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  event = "LspAttach",
  keys = wrap_keys {
    { "<leader>F", ":Format<Cr>", desc = "Format Using LSP", mode = { "n", "v" } },
  },

  config = function()
    require("mason-tool-installer").setup { ensure_installed = { "stylua", "prettier" } }
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        markdown = { "prettier" },
        angular = { "prettier" },
        css = { "prettier" },
        flow = { "prettier" },
        javascriptreact = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsx = { "prettier" },
        acss = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        tsx = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      ["_"] = { "trim_whitespace" },
      default_format_opts = { lsp_format = "fallback" },
    }
  end,
}
