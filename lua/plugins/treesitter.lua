local map = vim.keymap.set

return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
        {
            "kevinhwang91/nvim-ufo",
            dependencies = { "kevinhwang91/promise-async" },
            config = function()
                local ufo = require("ufo")

                ufo.setup({
                    provider_selector = function(bufnr, filetype, buftype)
                        return { "treesitter", "indent" }
                    end
                })
            end
        }

    },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "lua",
            "python",
            "javascript",
            "typescript",
            "jsx",
            "tsx",
            "css",
            "html",
            "vimdoc",
            "vim",
            "json",
            "gitignore",
            "markdown",
            "bash",
        },
        auto_install = true,
        autotag = { enable = true },
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = true, disable = { "ruby" } },
    },
}
