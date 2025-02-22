local bg_transparent = true

return {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local render = function ()

            require("onedarkpro").setup({
                options = {
                    transparency = bg_transparent,
                }
            })
            vim.cmd("colorscheme onedark_dark")
        end
        render()

        local toggle_transparency = function()
            bg_transparent = not bg_transparent
            render()
        end

        require('utils.map')( "<leader>bg", toggle_transparency, "Toggle Background transparency")
    end,
}
