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
        },
        config = function()
            require("venv-selector").setup({
                settings = {
                    options = {
                        picker = "snacks",
                    },
                },
            })
        end,
    },

    -- Huff syntax highlighting
    { "mouseless0x/vim-huff", ft = "huff" },

    -- Claude Code integration
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim", "folke/which-key.nvim" },
        config = function()
            require("claudecode").setup()

            require("which-key").add({
                { "<leader>c", group = "+Claude" },
                { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
                { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
                { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
                { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
                { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
                { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
                { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
                { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
                { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
            })
        end,
    },
}
