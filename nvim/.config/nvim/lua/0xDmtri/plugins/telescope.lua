-- [[ Fuzzy Finder ]]

return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                    },
                },
            },
        })

        require("telescope").load_extension("fzf")
        require("telescope").load_extension("harpoon")

        local builtin = require("telescope.builtin")

        require("which-key").add({
            { "<leader>s", group = "+Search" },
            { "<leader>sG", builtin.git_files, desc = "Git Files" },
            { "<leader>sf", builtin.find_files, desc = "Files" },
            { "<leader>sh", builtin.help_tags, desc = "Help Tags" },
            { "<leader>sw", builtin.grep_string, desc = "Word" },
            { "<leader>sg", builtin.live_grep, desc = "Grep" },
        })

        vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
        vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })
    end,
}
