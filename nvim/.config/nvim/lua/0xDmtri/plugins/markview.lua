-- [[ Markview ]]

local document_filetypes = { "markdown", "quarto", "rmd", "typst", "asciidoc" }

return {
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "folke/which-key.nvim",
            "saghen/blink.cmp",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>mp", "<cmd>Markview toggle<cr>", desc = "Toggle document preview" },
            { "<leader>mh", "<cmd>Markview hybridToggle<cr>", desc = "Toggle hybrid preview" },
            { "<leader>ml", "<cmd>Markview linewiseToggle<cr>", desc = "Toggle linewise hybrid" },
            { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Toggle document split" },
            { "<leader>mc", "<cmd>Checkbox toggle<cr>", desc = "Toggle checkbox" },
            { "<leader>mc", ":'<,'>Checkbox toggle<cr>", mode = "x", desc = "Toggle checkboxes" },
            { "<leader>m+", "<cmd>Heading increase<cr>", desc = "Increase heading level" },
            { "<leader>m-", "<cmd>Heading decrease<cr>", desc = "Decrease heading level" },
            { "<leader>me", "<cmd>Editor edit<cr>", desc = "Edit code block" },
            { "<leader>mn", "<cmd>Editor create<cr>", desc = "Create code block" },
        },
        opts = {
            experimental = {
                prefer_nvim = true,
            },
            preview = {
                icon_provider = "devicons",
                filetypes = document_filetypes,
                ignore_buftypes = { "nofile" },
                condition = function(buffer)
                    return vim.api.nvim_buf_is_valid(buffer)
                        and vim.bo[buffer].buflisted
                        and vim.bo[buffer].buftype == ""
                        and vim.tbl_contains(document_filetypes, vim.bo[buffer].filetype)
                end,
                modes = { "n", "no", "c", "i" },
                hybrid_modes = { "i" },
            },
        },
        config = function(_, opts)
            require("markview").setup(opts)

            require("markview.extras.checkboxes").setup({})
            require("markview.extras.headings").setup()
            require("markview.extras.editor").setup()

            require("which-key").add({
                { "<leader>m", group = "+Markview" },
            })
        end,
    },
}
