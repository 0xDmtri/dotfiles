-- [[ Snacks ]]

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true, timeout = 3000 },
        words = { enabled = true },
    },
    init = function()
        -- Wire up vim.ui overrides early so other plugins see them
        vim.ui.select = function(...) return require("snacks").picker.select(...) end
        vim.ui.input = function(...) return require("snacks").input(...) end
    end,
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
        vim.keymap.set("n", "<leader><space>", function() snacks.picker.smart() end, { desc = "[ ] Smart find" })
        vim.keymap.set("n", "<leader>/", function() snacks.picker.lines() end, { desc = "[/] Fuzzily search in current buffer" })
    end,
}
