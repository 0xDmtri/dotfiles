-- [[ Configure LSP ]]

-- Setup neovim dev tools for lua
require("neodev").setup({})

-- setup LSP-ZERO
local lsp_zero = require("lsp-zero")

-- helper for binds
local nmap = function(bufnr, keys, func, desc)
	if desc then
		desc = "LSP: " .. desc
	end

	vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
end

-- LSP settings on attach
local lsp_attach = function(client, bufnr)
	-- LSP keymap
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

	-- if available, toggle inlay-hints
	local toggle_inlay = function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { buffer = bufnr })
	end

	if client.server_capabilities.inlayHintProvider then
		vim.keymap.set({ "n", "i", "v" }, "<M-h>", toggle_inlay, { buffer = bufnr })
	end
end

-- setup null-ls
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		-- Formattings
		null_ls.builtins.formatting.forge_fmt,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,

		-- Diagnostics
		null_ls.builtins.diagnostics.solhint,
	},
})

-- enable format on save
lsp_zero.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 500,
	},
	servers = {
		-- Langs that will use null-ls for formatting
		["null-ls"] = { "javascript", "typescript", "python", "solidity", "lua" },

		-- Langs that will use non-lsp formatters
		["rust-analyzer"] = { "rust" },
	},
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	formatting = lsp_zero.cmp_format({ details = false }),
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
	}, {
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
	}, {
		{ name = "cmdline" },
	}),
})

-- apply extended config to LspZero
lsp_zero.extend_lspconfig({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	lsp_attach = lsp_attach,
	float_border = "rounded",
	sign_text = true,
})

-- initialize rust_analyzer with rustaceanvim
vim.g.rustaceanvim = {
	-- LSP configuration
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
	server = {
		capabilities = lsp_zero.get_capabilities(),
		standalone = false,
		hover_actions = { auto_focus = true },
		runnables = { use_telescope = true },
		on_attach = function(_, bufnr)
			-- Rust Specific keymaps
			nmap(bufnr, "<leader>a", "<cmd>RustLsp hover actions<CR>", "[A]ctions Hover")
			nmap(bufnr, "<leader>ca", "<cmd>RustLsp codeAction<CR>", "[C]ode [A]ction")
			nmap(bufnr, "<leader>cr", "<cmd>RustLsp runnables<CR>", "[C]argo [R]unnables")
			nmap(bufnr, "<leader>ct", "<cmd>RustLsp openCargo<CR>", "[C]argo Toml")
			nmap(bufnr, "<leader>p", "<cmd>RustLsp parentModule<CR>", "[P]arent Module")
			nmap(bufnr, "<leader>e", "<cmd>RustLsp explainError<CR>", "[E]xplain Error")
		end,
		default_settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
					extraArgs = { "--all", "--", "-W", "clippy::all" },
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
				},
				assist = {
					importMergeBehavior = "last",
					importPrefix = "by_self",
				},
				imports = {
					granularity = {
						group = "crate", -- Group imports by crate
					},
					group_imports = "std", -- Group standard library imports separately
					prefix_kind = "plain", -- Use plain paths for imports
				},
			},
		},
	},
}

-- Setup Mason and Mason-LspConfig
require("mason").setup({})
require("mason-lspconfig").setup({
	-- Ensure these servers are installed via Mason
	ensure_installed = {
		-- LSPs:
		-- NOTE: rust-analyzer is installed via cargo
		"lua_ls",
		"ts_ls",
		"solidity_ls_nomicfoundation",
		"pyright",
	},
	handlers = {
		function(server_name)
			if server_name == "lua_ls" then
				require("lspconfig").lua_ls.setup({
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }, -- Avoid warnings for 'vim'
								disable = { "missing-fields" }, -- Disable the specific warning
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
								checkThirdParty = false, -- Avoid prompts about third-party libraries
							},
							telemetry = { enable = false }, -- Disable telemetry for privacy
						},
					},
				})
			else
				require("lspconfig")[server_name].setup({})
			end
		end,
	},
})
