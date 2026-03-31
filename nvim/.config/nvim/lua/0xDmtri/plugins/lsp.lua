-- [[ LSP Configuration ]]

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
    nmap(bufnr, "gd", "<cmd>Lspsaga finder def<CR>", "Definition")
    nmap(bufnr, "gD", vim.lsp.buf.declaration, "Declaration")
    nmap(bufnr, "gi", "<cmd>Lspsaga finder imp<CR>", "Implementation")

    -- Frequently used mappings
    nmap(bufnr, "<leader>a", "<cmd>Lspsaga code_action<CR>", "Code Action")
    nmap(bufnr, "<leader>n", "<cmd>Lspsaga rename<CR>", "Rename")
    nmap(bufnr, "<leader>d", "<cmd>Lspsaga finder tyd<CR>", "Type Definition")
    nmap(bufnr, "<leader>o", "<cmd>Lspsaga outline<CR>", "Outline")
    nmap(bufnr, "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")

    -- LSP x Snacks Picker
    nmap(bufnr, "<leader>ss", function()
        require("snacks").picker.lsp_symbols()
    end, "Symbols")
    nmap(bufnr, "<leader>sd", function()
        require("snacks").picker.diagnostics()
    end, "Diagnostics")

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

return {
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", config = true },
            "neovim/nvim-lspconfig",
            { "j-hui/fidget.nvim", opts = {} },
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "solidity_ls_nomicfoundation",
                    "pyright",
                    "ruff",
                },
            })

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "missing-fields" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            ignore = { "*" },
                        },
                    },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    lsp_attach(client, args.buf)
                end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    if client:supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({
                            event = "BufWritePre",
                            buffer = args.buf,
                        })
                    end
                end,
            })
        end,
    },

    {
        "nvimdev/lspsaga.nvim",
        name = "lspsaga",
        event = "LspAttach",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("lspsaga").setup({
                move_in_saga = {
                    prev = "<C-k>",
                    next = "<C-j>",
                },
                finder_action_keys = {
                    open = "<CR>",
                },
                definition_action_keys = {
                    edit = "<CR>",
                },
                ui = {
                    border = "rounded",
                },
            })
            vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>Lspsaga term_toggle<CR>")
        end,
    },
}
