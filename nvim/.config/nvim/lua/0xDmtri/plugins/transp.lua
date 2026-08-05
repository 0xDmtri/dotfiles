-- [[ Transparent Background ]]

return {
    "xiyaowong/transparent.nvim",
    config = function()
        require("transparent").setup({
            extra_groups = {
                "LspFloatWinNormal",
                "NormalFloat",
                "FloatBorder",

                "GitSignsAdd",
                "GitSignsChange",
                "GitSignsDelete",

                "SagaNormal",
                "SagaBorder",
            },
        })

        vim.api.nvim_create_user_command("Lucid", function()
            vim.cmd("TransparentEnable")
        end, {})

        vim.api.nvim_create_user_command("Solid", function()
            vim.cmd("TransparentDisable")
        end, {})
    end,
}
