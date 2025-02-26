local bg_transparent = true

return {
    "bluz71/vim-nightfly-colors",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.nightflyCursorColor = true
        vim.g.nightflyWinSeparator = 2
        vim.cmd [[colorscheme nightfly]]
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = vim.api.nvim_get_hl_by_name('Normal', true).background })

        local set_transparency = function()
            local bg = 'none' 
            if not bg_transparent then
                bg = '#080808' 
            end

            local allHighlights = {'Normal', 'NormalFloat', 'Error', 'ErrorMsg', 'WarinigMsg' , 'LineNr', 'SignColumn' , 'SpecialKey', 'FloatBorder', 'NvimTreeNormalFloat' , 'MatchWordCur'}
            for _, hl in pairs(allHighlights) do
                vim.api.nvim_set_hl(0, hl, { bg = bg })
            end
        end

        local toggle_transparent = function()
            bg_transparent = not bg_transparent
            set_transparency()
        end

        set_transparency()
        require("utils.map")("<leader>bg", toggle_transparent, "Toggle transparency")
    end
}
