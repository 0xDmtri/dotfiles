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
            },
        })

        require("which-key").add({
            { "<leader>\\", group = "+Neotree" },
            { "<leader>\\b", "<cmd>Neotree source=buffers toggle<cr>", desc = "Buffers" },
            { "<leader>\\g", "<cmd>Neotree source=git_status toggle<cr>", desc = "Git Status" },
        })

        vim.keymap.set("n", "\\", "<cmd>Neotree toggle reveal_force_cwd<cr>", { silent = true })
    end,
}
