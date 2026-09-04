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
    local snacks = require("snacks")

    -- GOTO mappings
    nmap(bufnr, "gr", function()
        snacks.picker.lsp_references({ include_current = true })
    end, "References")
    nmap(bufnr, "gd", function()
        snacks.picker.lsp_definitions({ include_current = true })
    end, "Definition")
    nmap(bufnr, "gD", vim.lsp.buf.declaration, "Declaration")
    nmap(bufnr, "gi", function()
        snacks.picker.lsp_implementations({ include_current = true })
    end, "Implementation")

    -- Frequently used mappings
    nmap(bufnr, "<leader>a", vim.lsp.buf.code_action, "Code Action")
    nmap(bufnr, "<leader>n", vim.lsp.buf.rename, "Rename")
    nmap(bufnr, "<leader>d", function()
        snacks.picker.lsp_type_definitions({ include_current = true })
    end, "Type Definition")
    nmap(bufnr, "<leader>o", function()
        snacks.picker.lsp_symbols({ layout = { preset = "sidebar", layout = { position = "right" } } })
    end, "Outline")
    nmap(bufnr, "K", function()
        vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover Documentation")

    -- LSP x Snacks Picker
    nmap(bufnr, "<leader>ss", function()
        snacks.picker.lsp_symbols()
    end, "Symbols")
    nmap(bufnr, "<leader>sd", function()
        snacks.picker.diagnostics()
    end, "Diagnostics")

    -- in INSERT mode only
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

    -- Diagnostic keymaps
    nmap(bufnr, "<leader>D", function()
        vim.diagnostic.open_float({ scope = "cursor", border = "rounded", source = "if_many" })
    end, "Diagnostics")
    nmap(bufnr, "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev diagnostic msg")
    nmap(bufnr, "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic msg")
    nmap(bufnr, "<leader>q", function()
        snacks.picker.diagnostics_buffer()
    end, "Open diagnostic list")

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
                    "stylua",
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

            local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = lsp_group,
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    lsp_attach(client, args.buf)
                end,
            })
        end,
    },
}
