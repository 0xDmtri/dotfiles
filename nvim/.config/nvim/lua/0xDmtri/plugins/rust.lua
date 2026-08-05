-- [[ Rust Development ]]

return {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.g.rustaceanvim = {
            tools = {
                float_win_config = {
                    auto_focus = true,
                },
                enable_clippy = true,
            },
            server = {
                capabilities = capabilities,
                standalone = false,
                default_settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                            extraArgs = { "--all", "--no-deps", "--", "-W", "clippy::all" },
                            features = "all",
                        },
                        cargo = {
                            features = "all",
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true,
                        },
                        completion = {
                            autoimport = {
                                enable = true,
                            },
                            postfix = {
                                enable = true,
                            },
                        },
                        imports = {
                            granularity = {
                                group = "crate",
                            },
                            prefix = "self",
                            merge = {
                                glob = true,
                            },
                        },
                        rustfmt = {
                            extraArgs = { "+nightly" },
                        },
                        semanticHighlighting = {
                            strings = {
                                enable = true,
                            },
                        },
                        lens = {
                            enable = true,
                        },
                    },
                },
            },
        }
    end,
}
