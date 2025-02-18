
return {
    "monkoose/neocodeium",
    -- cmd = { "NeoCodeium" },
    config = function()
        local neocodeium = require("neocodeium").setup(
            {
                enable = false,
                filetypes = {
                    TelescopePrompt = false,
                    ["dap-repl"] = false,
                },
            }

        )
        neocodeium.setup()

        vim.keymap.set("n", "<leader>cn", ":NeoCodeium toggle<CR>",
            { noremap = true, silent = true, desc = "Toggle NeoCodeium" })
        vim.keymap.set("n", "<leader>cc", ":NeoCodeium chat<CR>",
            { noremap = true, silent = true, desc = "Chat with Codeium" })
        vim.keymap.set("n", "<leader>cr", ":NeoCodeium restart<CR>",
            { noremap = true, silent = true, desc = "Codeium Restart" })
        vim.keymap.set("n", "<leader>cb", ":NeoCodeium toggle_buffer<CR>",
            { noremap = true, silent = true, desc = "Toggle NeoCodeium Buffer" })
        vim.keymap.set("i", "<A-f>", neocodeium.accept)
        vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
        vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
        vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
        vim.keymap.set("i", "<A-r>", neocodeium.cycle_or_complete)
        vim.keymap.set("i", "<A-c>", neocodeium.clear)
        vim.keymap.set({ "i", "n", "v" }, "<A-b>", neocodeium.toggle_buffer)
    end,
}
