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
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal = {
                snacks_win_opts = {
                    position = "float",
                    width = 0.9,
                    height = 0.9,
                    keys = {
                        claude_hide = {
                            "<C-,>",
                            function(self)
                                self:hide()
                            end,
                            mode = "t",
                            desc = "Hide Claude",
                        },
                    },
                },
            },
        },
        keys = {
            { "<C-,>", "<cmd>ClaudeCodeFocus<cr>", desc = "Toggle Claude", mode = { "n", "x" } },
            { "<leader>c", nil, desc = "+Claude" },
            { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>cs",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "neo-tree", "oil", "netrw" },
            },
            { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
            { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
        },
    },
}
