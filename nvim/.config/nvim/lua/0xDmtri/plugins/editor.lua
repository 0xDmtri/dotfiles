-- [[ Editor Plugins ]]

return {
    -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-sleuth" },

    -- Lua development
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Keybinding helper
    { "folke/which-key.nvim", opts = {} },

    -- Auto matching brackets
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Python env selector
    {
        "linux-cultist/venv-selector.nvim",
        branch = "main",
        ft = "python",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("venv-selector").setup({})
        end,
    },

    -- Huff syntax highlighting
    { "mouseless0x/vim-huff", ft = "huff" },

    -- Claude Code integration
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("claude-code").setup()
        end,
    },
}
