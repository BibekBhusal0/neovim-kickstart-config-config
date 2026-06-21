local wrap_keys = require "utils.wrap_keys"

local function format()
  require("conform").format()
end

return {
  "stevearc/conform.nvim",
  dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  event = "LspAttach",
  keys = wrap_keys { { "<leader>F", format, desc = "Format Using LSP" } },
  config = function()
    require("mason-tool-installer").setup { "stylua", "prettier" }

    local conform = require "conform"
    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        md = { "prettier" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      ["_"] = { "trim_whitespace" },
      default_format_opts = { lsp_format = "fallback" },
    }
  end,
}
