-- [[ Transparent Background ]]

return {
    "xiyaowong/transparent.nvim",
    config = function()
        local function setFidget(transparent)
            local ok, fidget = pcall(require, "fidget")
            if ok then
                fidget.setup({
                    notification = {
                        window = { winblend = transparent and 0 or 100 },
                    },
                })
            end
        end

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

        setFidget(vim.g.transparent_enabled)

        vim.api.nvim_create_user_command("Lucid", function()
            setFidget(true)
            vim.cmd("TransparentEnable")
        end, {})

        vim.api.nvim_create_user_command("Solid", function()
            setFidget(false)
            vim.cmd("TransparentDisable")
        end, {})
    end,
}
