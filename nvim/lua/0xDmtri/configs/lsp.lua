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
	nmap(bufnr, "gr", "<cmd>Lspsaga finder ref<CR>", "[G]oto [R]eferences")
	nmap(bufnr, "gd", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap(bufnr, "gD", "<cmd>Lspsaga finder def<CR>", "[G]oto [D]efinition")
	nmap(bufnr, "gI", "<cmd>Lspsaga finder imp<CR>", "[G]oto [I]mplementation")
	nmap(bufnr, "<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
	nmap(bufnr, "<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
	nmap(bufnr, "<leader>d", "<cmd>Lspsaga finder tyd<CR>", "Type [D]efinition")
	nmap(bufnr, "<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch document [S]ymbols")
	nmap(bufnr, "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
	nmap(bufnr, "<leader>o", "<cmd>Lspsaga outline<CR>", "[O]utline")

	-- in INSERT mode only
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

	-- Diagnostic keymaps
	nmap(bufnr, "<leader>D", "<cmd>Lspsaga show_cursor_diagnostics<CR>", "[D]iagnostics")
	nmap(bufnr, "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to prev diagnostic msg")
	nmap(bufnr, "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic msg")
	nmap(bufnr, "<leader>q", "<cmd>Lspsaga show_buf_diagnostics<CR>", "Open diagnostic list")

	-- Rust Specific keymaps
	if client.name == "rust_analyzer" then
		nmap(bufnr, "<leader>a", "<cmd>RustLsp hover actions<CR>", "[A]ctions Hover")
		nmap(bufnr, "<leader>ca", "<cmd>RustLsp codeAction<CR>", "[C]ode [A]ction")
		nmap(bufnr, "<leader>cr", "<cmd>RustLsp runnables<CR>", "[C]argo [R]unnables")
		nmap(bufnr, "<leader>ct", "<cmd>RustLsp openCargo<CR>", "[C]argo Toml")
		nmap(bufnr, "<leader>p", "<cmd>RustLsp parentModule<CR>", "[P]arent Module")
		nmap(bufnr, "<leader>e", "<cmd>RustLsp explainError<CR>", "[E]xplain Error")
	end

	-- if available, toggle inlay-hints
	local toggle_inlay = function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { buffer = bufnr })
	end

	if client.server_capabilities.inlayHintProvider then
		vim.keymap.set({ "n", "i", "v" }, "<M-h>", toggle_inlay, { buffer = bufnr })
	end
end

-- Get default capabilities for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup Mason and Mason-LspConfig
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"ts_ls",
		"solidity_ls_nomicfoundation",
		"pyright",
	},
	handlers = {
		function(server_name)
			-- Do not configure rust_analyzer as it will be configure via Rustaceanvim below
			if server_name ~= "rust_analyzer" then
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
	},
})

-- Initialize rust_analyzer with rustaceanvim
vim.g.rustaceanvim = {
	-- LSP configuration
	tools = {
		hover_actions = {
			auto_focus = true,
		},
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
					extraArgs = { "--all", "--", "-W", "clippy::all" },
					allFeatures = true,
				},
				cargo = {
					features = "all",
				},
				procMacro = {
					enable = true,
				},
				imports = {
					granularity = {
						group = "crate", -- Group imports by crate
					},
					prefix = "self", -- Use plain paths for imports
				},
				rustfmt = {
					extraArgs = { "+nightly" },
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
		python = { "isort", "black" },
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

-- Setup nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-x>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "crates" },
		{ name = "path" },
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

-- Load VSCode-style snippets
require("luasnip.loaders.from_vscode").lazy_load()
