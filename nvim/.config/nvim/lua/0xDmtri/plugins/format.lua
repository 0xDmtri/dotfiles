-- [[ Formatting & Linting ]]

return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff_format", "ruff_organize_imports" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    solidity = { "forge_fmt" },

                    ["_"] = { "trim_whitespace", lsp_format = "prefer" },
                },
                format_on_save = {
                    timeout_ms = 500,
                },
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                solidity = { "solhint" },
            }
            vim.api.nvim_create_autocmd("BufWritePost", {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
