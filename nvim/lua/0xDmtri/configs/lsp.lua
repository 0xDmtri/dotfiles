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
    -- GOTO mappings
    nmap(bufnr, "gr", "<cmd>Lspsaga finder ref<CR>", "References")
    nmap(bufnr, "gd", vim.lsp.buf.declaration, "Declaration")
    nmap(bufnr, "gD", "<cmd>Lspsaga finder def<CR>", "Definition")
    nmap(bufnr, "gi", "<cmd>Lspsaga finder imp<CR>", "Implementation")

    -- Frequently used mappings
    nmap(bufnr, "<leader>a", "<cmd>Lspsaga code_action<CR>", "Code Action")
    nmap(bufnr, "<leader>n", "<cmd>Lspsaga rename<CR>", "Rename")
    nmap(bufnr, "<leader>d", "<cmd>Lspsaga finder tyd<CR>", "Type Definition")
    nmap(bufnr, "<leader>o", "<cmd>Lspsaga outline<CR>", "Outline")
    nmap(bufnr, "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")

    -- LSP x Telescope
    nmap(bufnr, "<leader>ss", require("telescope.builtin").lsp_document_symbols, "Symbols")
    nmap(bufnr, "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")

    -- in INSERT mode only
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

    -- Diagnostic keymaps
    nmap(bufnr, "<leader>D", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Diagnostics")
    nmap(bufnr, "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev diagnostic msg")
    nmap(bufnr, "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic msg")
    nmap(bufnr, "<leader>q", "<cmd>Lspsaga show_buf_diagnostics<CR>", "Open diagnostic list")

    -- if available, toggle inlay-hints
    if client.server_capabilities.inlayHintProvider then
        local toggle_inlay = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { buffer = bufnr })
        end
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
})

-- Configure rust-analyzer with Rustaceanvim
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
        on_attach = lsp_attach,
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

-- Configure capabilities for all lsp
vim.lsp.config("*", {
    capabilities = capabilities,
})

-- Configure lua lsp
vim.lsp.config("lua_ls", {
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

-- Configure pyright
vim.lsp.config("pyright", {
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

-- Apply key-bindings on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- Get the client
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Attach key-bindings
        lsp_attach(client, args.buf)
    end,
})

-- Clean up on LspDetach
vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        -- Get the detaching client
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Remove the autocommand to format the buffer on save, if it exists
        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                event = "BufWritePre",
                buffer = args.buf,
            })
        end
    end,
})

-- Setup Conform formatter
require("conform").setup({
    formatters_by_ft = {
        -- Set specific formatters per language
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        solidity = { "forge_fmt" },

        -- Use LSP formatting if no specific formatters configured,
        -- trim whitespace if no LSP formatters found
        ["_"] = { "trim_whitespace", lsp_format = "prefer" },
    },
    format_on_save = {
        timeout_ms = 500,
    },
})

-- Setup nvim-lint
require("lint").linters_by_ft = {
    solidity = { "solhint" },
}
vim.api.nvim_create_autocmd("BufWritePost", {
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
    },

    -- use LSP native signature help until this is stable
    signature = {
        enabled = false,
    },

    cmdline = {
        -- inherit mappings from top level `keymap` config
        keymap = { preset = "inherit" },
    },

    completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
    },
})
