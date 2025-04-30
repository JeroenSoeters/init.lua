return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end)
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<S-s>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<S-w>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<S-e>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<S-r>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<S-t>", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader><S-w>", function() harpoon:list():replace_at(1) end)
        vim.keymap.set("n", "<leader><S-e>", function() harpoon:list():replace_at(2) end)
        vim.keymap.set("n", "<leader><S-r>", function() harpoon:list():replace_at(3) end)
        vim.keymap.set("n", "<leader><S-t>", function() harpoon:list():replace_at(4) end)
    end
}
