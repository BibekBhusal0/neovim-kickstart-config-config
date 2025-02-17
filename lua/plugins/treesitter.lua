return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
        {
            'luukvbaal/statuscol.nvim',
            opts = function()
                local builtin = require('statuscol.builtin')

                return {
                    setopt = true,
                    segments = {
                        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
                        {
                            text = { builtin.lnumfunc, '' },
                            click = 'v:lua.ScLa',
                        },
                        {
                            sign = { namespace = { 'gitsigns' } },
                            click = 'v:lua.ScSa',
                        },
                    },
                }
            end,
        },

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
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = true, disable = { "ruby" } },
    },
}
