-- [[ Configure LSP ]]

-- Setup neovim dev tools for lua
require("neodev").setup({})

-- helper for binds
local nmap = function(bufnr, keys, func, desc)
    if desc then
        desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
end

-- LSP settings on attach
local lsp_attach = function(client, bufnr)
    -- LSP general keymaps
    nmap(bufnr, "gr", "<cmd>Lspsaga finder ref<CR>", "Goto References")
    nmap(bufnr, "gd", vim.lsp.buf.declaration, "Goto Declaration")
    nmap(bufnr, "gD", "<cmd>Lspsaga finder def<CR>", "Goto Definition")
    nmap(bufnr, "gI", "<cmd>Lspsaga finder imp<CR>", "Goto Implementation")

    nmap(bufnr, "<leader>la", "<cmd>Lspsaga code_action<CR>", "Code Action")
    nmap(bufnr, "<leader>n", "<cmd>Lspsaga rename<CR>", "Rename")
    nmap(bufnr, "<leader>d", "<cmd>Lspsaga finder tyd<CR>", "Type Definition")
    nmap(bufnr, "<leader>o", "<cmd>Lspsaga outline<CR>", "Outline")

    nmap(bufnr, "<leader>ss", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
    nmap(bufnr, "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")

    -- in INSERT mode only
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

    -- Diagnostic keymaps
    nmap(bufnr, "<leader>D", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Diagnostics")
    nmap(bufnr, "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to prev diagnostic msg")
    nmap(bufnr, "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic msg")
    nmap(bufnr, "<leader>q", "<cmd>Lspsaga show_buf_diagnostics<CR>", "Open diagnostic list")

    -- if available, toggle inlay-hints
    local toggle_inlay = function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { buffer = bufnr })
    end

    if client.server_capabilities.inlayHintProvider then
        vim.keymap.set({ "n", "i", "v" }, "<M-h>", toggle_inlay, { buffer = bufnr })
    end
end

-- Get default capabilities for autocompletion
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Setup Mason and Mason-LspConfig
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ts_ls",
        "solidity_ls_nomicfoundation",
        "pyright",
        "ruff",
    },
    handlers = {
        function(server_name)
            -- Do not configure rust_analyzer as it will be configure via Rustaceanvim below
            if server_name ~= "rust-analyzer" then
                require("lspconfig")[server_name].setup({
                    on_attach = lsp_attach, -- Use your custom on_attach function
                    capabilities = capabilities, -- Pass extended capabilities
                })
            end
        end,
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
                on_attach = lsp_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }, -- Avoid warnings for 'vim'
                            disable = { "missing-fields" }, -- Disable specific warnings
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
                            checkThirdParty = false, -- Avoid prompts about third-party libraries
                        },
                        telemetry = { enable = false }, -- Disable telemetry for privacy
                    },
                },
            })
        end,
        ["pyright"] = function()
            require("lspconfig").pyright.setup({
                on_attach = lsp_attach,
                capabilities = capabilities,
                settings = {
                    pyright = {
                        disableOrganizeImports = true, -- Using Ruff
                    },
                    python = {
                        analysis = {
                            ignore = { "*" }, -- Using Ruff
                        },
                    },
                },
            })
        end,
    },
})

-- Initialize rust-analyzer with rustaceanvim
vim.g.rustaceanvim = {
    -- LSP configuration
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
        on_attach = lsp_attach,
        default_settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--all", "--no-deps", "--", "-W", "clippy::all" },
                    allFeatures = true,
                },
                cargo = {
                    allFeatures = true, -- Enable all features for Cargo
                    loadOutDirsFromCheck = true, -- Load output directories from check
                    runBuildScripts = true, -- Run build scripts
                },
                procMacro = {
                    enable = true, -- Enable procedural macro support
                },
                completion = {
                    autoimport = {
                        enable = true, -- Automatically insert missing imports on completion
                    },
                    postfix = {
                        enable = true, -- Enable postfix completions like .into()
                    },
                },
                imports = {
                    granularity = {
                        group = "crate", -- Group imports by crate
                    },
                    prefix = "self", -- Use plain paths for imports
                    merge = {
                        glob = true, -- Merge glob imports (e.g., use foo::{bar, baz})
                    },
                },
                rustfmt = {
                    extraArgs = { "+nightly" },
                },
                semanticHighlighting = {
                    strings = {
                        enable = true, -- Better highlighting for strings
                    },
                },
                lens = {
                    enable = true,
                },
            },
        },
    },
}

-- Setup Conform formatter
require("conform").setup({
    formatters_by_ft = {
        -- Set specific formatters per language
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        solidity = { "forge_fmt" },

        -- Use LSP formatting if no specific formatters configured
        default_format_opts = {
            lsp_format = "fallback",
        },

        -- Trim whitespace if no other formatters configured,
        -- and no LSP formatters found
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
    },
})

-- Setup nvim-lint
require("lint").linters_by_ft = {
    markdown = { "vale" },
    solidity = { "solhint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

-- Setup blink.cmp
local blink = require("blink.cmp")

blink.setup({
    keymap = {
        -- do NOT set any preset keymaps
        preset = "none",

        -- set own custom keymaps
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-x>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-j>"] = { "select_next", "fallback_to_mappings" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        -- use LSP native signature help until this is stable
        -- ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },

    -- use LSP native signature help until this is stable
    signature = {
        enabled = false,
    },

    cmdline = {
        -- inherit mappings from top level `keymap` config
        keymap = { preset = "inherit" },
    },
})
