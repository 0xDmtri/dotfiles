-- [[ Syntax Highlighting & Code Objects ]]

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "c",
                    "go",
                    "lua",
                    "python",
                    "rust",
                    "zig",
                    "tsx",
                    "typescript",
                    "javascript",
                    "julia",
                    "vimdoc",
                    "vim",
                    "solidity",
                    "markdown",
                    "markdown_inline",
                    "toml",
                    "html",
                    "css",
                },
            })

            vim.treesitter.language.register("markdown", "mdx")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            -- Select keymaps
            local select = function(capture, query)
                return function()
                    require("nvim-treesitter-textobjects.select").select_textobject(capture, query)
                end
            end

            vim.keymap.set({ "x", "o" }, "aa", select("@parameter.outer", "textobjects"))
            vim.keymap.set({ "x", "o" }, "ia", select("@parameter.inner", "textobjects"))
            vim.keymap.set({ "x", "o" }, "af", select("@function.outer", "textobjects"))
            vim.keymap.set({ "x", "o" }, "if", select("@function.inner", "textobjects"))
            vim.keymap.set({ "x", "o" }, "ac", select("@class.outer", "textobjects"))
            vim.keymap.set({ "x", "o" }, "ic", select("@class.inner", "textobjects"))

            -- Move keymaps
            local move = require("nvim-treesitter-textobjects.move")
            vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("treesitter-context").setup({
                max_lines = 5,
            })
        end,
    },
}
