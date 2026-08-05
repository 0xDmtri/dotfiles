-- [[ Theme & UI ]]

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "auto",
                dark_variant = "main",
                enable = {
                    terminal = true,
                    legacy_highlights = true,
                },
                styles = {
                    transparency = vim.g.transparent_enabled,
                },
            })
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    icons_enabled = true,
                    component_separators = "|",
                    section_separators = "",
                    disabled_filetypes = { "lazy", "snacks_picker_list" },
                },
            })
        end,
    },
}
