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

    -- Codex integration
    {
        "ishiooon/codex.nvim",
        dependencies = { "folke/snacks.nvim" },
        cmd = {
            "Codex",
            "CodexFocus",
            "CodexAdd",
            "CodexSend",
            "CodexTreeAdd",
            "CodexSelectModel",
            "CodexDiffAccept",
            "CodexDiffDeny",
        },
        opts = {
            terminal_cmd = "/opt/homebrew/bin/codex",
            keymaps = false,
            status_indicator = {
                enabled = false,
            },
            terminal = {
                provider = "snacks",
                snacks_win_opts = {
                    position = "float",
                    width = 0.9,
                    height = 0.9,
                    keys = {
                        codex_hide = {
                            "<C-,>",
                            function(self)
                                self:hide()
                            end,
                            mode = "t",
                            desc = "Hide Codex",
                        },
                    },
                },
            },
        },
        keys = {
            { "<C-,>", "<cmd>CodexFocus<cr>", desc = "Toggle Codex", mode = { "n", "x" } },
            { "<leader>c", nil, desc = "+Codex" },
            { "<leader>cc", "<cmd>Codex<cr>", desc = "Toggle Codex" },
            { "<leader>cr", "<cmd>Codex resume --last<cr>", desc = "Resume Codex" },
            { "<leader>cb", "<cmd>CodexAdd %<cr>", desc = "Add current buffer" },
            { "<leader>cs", "<cmd>CodexSend<cr>", mode = "v", desc = "Send to Codex" },
            {
                "<leader>cs",
                "<cmd>CodexTreeAdd<cr>",
                desc = "Add file",
                ft = { "neo-tree", "oil" },
            },
            { "<leader>cm", "<cmd>CodexSelectModel<cr>", desc = "Select model" },
            { "<leader>ca", "<cmd>CodexDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>cd", "<cmd>CodexDiffDeny<cr>", desc = "Reject diff" },
        },
    },
}
