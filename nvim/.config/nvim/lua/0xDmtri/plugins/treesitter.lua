-- [[ Syntax Highlighting & Code Objects ]]

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            -- Markview's AsciiDoc support uses two parsers from the same repository.
            vim.api.nvim_create_autocmd("User", {
                group = vim.api.nvim_create_augroup("markview_asciidoc_parsers", { clear = true }),
                pattern = "TSUpdate",
                desc = "Register Markview's AsciiDoc parsers",
                callback = function()
                    local parsers = require("nvim-treesitter.parsers")

                    parsers.asciidoc = {
                        install_info = {
                            branch = "master",
                            location = "tree-sitter-asciidoc",
                            queries = "queries/asciidoc",
                            url = "https://github.com/cathaysia/tree-sitter-asciidoc",
                        },
                        requires = { "asciidoc_inline" },
                        tier = 2,
                    }
                    parsers.asciidoc_inline = {
                        install_info = {
                            branch = "master",
                            location = "tree-sitter-asciidoc_inline",
                            queries = "queries/asciidoc_inline",
                            url = "https://github.com/cathaysia/tree-sitter-asciidoc",
                        },
                        tier = 2,
                    }
                end,
            })

            require("nvim-treesitter").install({
                "asciidoc",
                "asciidoc_inline",
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
                "latex",
                "typst",
                "yaml",
                "css",
                "regex",
            })

            vim.treesitter.language.register("markdown", { "mdx", "quarto", "rmd" })

            -- Enable treesitter highlighting for all installed parsers
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    if pcall(vim.treesitter.start, args.buf) then
                        -- Disable legacy syntax when treesitter is active
                        vim.bo[args.buf].syntax = ""
                    end
                end,
            })
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
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end)
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
