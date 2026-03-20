-- [[ Fuzzy Finder ]]

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = { enabled = true },
        indent = { enabled = true },
    },
    config = function(_, opts)
        local snacks = require("snacks")
        snacks.setup(opts)

        require("which-key").add({
            { "<leader>s", group = "+Search" },
            { "<leader>sG", function() snacks.picker.git_files() end, desc = "Git Files" },
            { "<leader>sf", function() snacks.picker.files() end, desc = "Files" },
            { "<leader>sh", function() snacks.picker.help() end, desc = "Help Tags" },
            { "<leader>sw", function() snacks.picker.grep_word() end, desc = "Word" },
            { "<leader>sg", function() snacks.picker.grep() end, desc = "Grep" },
        })

        vim.keymap.set("n", "<leader>?", function() snacks.picker.recent() end, { desc = "[?] Find recently opened files" })
        vim.keymap.set("n", "<leader><space>", function() snacks.picker.buffers() end, { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>/", function() snacks.picker.lines() end, { desc = "[/] Fuzzily search in current buffer" })
    end,
}
