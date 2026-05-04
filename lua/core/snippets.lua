-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  float = {
    border = "rounded",
    source = "if_many",
    focusable = true,
    severity_sort = true,
    header = "",
  },
}
