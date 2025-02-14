local bg_transparent = true

return {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require("onedarkpro").setup({
            options = {
                transparency = bg_transparent,
            }
        })
        vim.cmd("colorscheme onedark_dark")

        local toggle_transparency = function()
            bg_transparent = not bg_transparent
            require("onedarkpro").setup({
                options = {
                    transparency = bg_transparent,
                }
            })
            vim.cmd("colorscheme onedark_dark")
        end

        vim.keymap.set('n', '<leader>bg', toggle_transparency,
            { noremap = true, silent = true, desc = "Toggle background transparency" })
    end,
}
