-- [[ Rust Development ]]

return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.g.rustaceanvim = {
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
                enable_clippy = true,
            },
            server = {
                capabilities = capabilities,
                standalone = false,
                hover_actions = { auto_focus = true },
                runnables = { use_telescope = true },
                default_settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                            extraArgs = { "--all", "--no-deps", "--", "-W", "clippy::all" },
                            allFeatures = true,
                        },
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
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
