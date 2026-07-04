return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { cmp = { enabled = true } },
    },
  },
}
