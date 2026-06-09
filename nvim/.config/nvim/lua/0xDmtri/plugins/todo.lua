-- [[ Todo Comments ]]

return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
        "TodoQuickFix",
        "TodoLocList",
        "TodoTelescope",
        "TodoFzfLua",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = true,
        highlight = {
            comments_only = true,
            keyword = "wide",
            after = "fg",
            max_line_len = 400,
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
            },
            pattern = [[\b(KEYWORDS):]],
        },
    },
    keys = {
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Next todo",
        },
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Previous todo",
        },
        { "<leader>st", "<cmd>TodoQuickFix<cr>", desc = "Todo quickfix" },
        { "<leader>sT", "<cmd>TodoLocList<cr>", desc = "Todo loclist" },
    },
}
