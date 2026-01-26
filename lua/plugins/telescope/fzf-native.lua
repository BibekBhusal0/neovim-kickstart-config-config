return {
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
  enabled = false,
  config = function()
    require("telescope").load_extension "fzf"
    require("telescope").setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    }
  end,
}
