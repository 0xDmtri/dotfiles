-- [[ File Tree ]]

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            window = {
                position = "right",
            },

            filesystem = {
                use_libuv_file_watcher = true,
                async_directory_scan = "never",
            },
        })

        vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd <CR>", { silent = true })
        vim.keymap.set("n", "<leader>\\b", ":Neotree source=buffers toggle<CR>", { desc = "Neotree Buffer" })
        vim.keymap.set("n", "<leader>\\g", ":Neotree source=git_status toggle<CR>", { desc = "Neotree Git Status" })
    end,
}
