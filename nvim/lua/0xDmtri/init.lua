--[[

=====================================================================
  ______             _______                   __                __
 /      \           /       \                 /  |              /  |
/₿₿₿₿₿₿  | __    __ ₿₿₿₿₿₿₿  | _____  ____   _₿₿ |_     ______  ₿₿/
₿₿₿  \₿₿ |/  \  /  |₿₿ |  ₿₿ |/     \/    \ / ₿₿   |   /      \ /  |
₿₿₿₿  ₿₿ |₿₿  \/₿₿/ ₿₿ |  ₿₿ |₿₿₿₿₿₿ ₿₿₿₿  |₿₿₿₿₿₿/   /₿₿₿₿₿₿  |₿₿ |
₿₿ ₿₿ ₿₿ | ₿₿  ₿₿<  ₿₿ |  ₿₿ |₿₿ | ₿₿ | ₿₿ |  ₿₿ | __ ₿₿ |  ₿₿/ ₿₿ |
₿₿ \₿₿₿₿ | /₿₿₿₿  \ ₿₿ |__₿₿ |₿₿ | ₿₿ | ₿₿ |  ₿₿ |/  |₿₿ |      ₿₿ |
₿₿   ₿₿₿/ /₿₿/ ₿₿  |₿₿    ₿₿/ ₿₿ | ₿₿ | ₿₿ |  ₿₿  ₿₿/ ₿₿ |      ₿₿ |
 ₿₿₿₿₿₿/  ₿₿/   ₿₿/ ₿₿₿₿₿₿₿/  ₿₿/  ₿₿/  ₿₿/    ₿₿₿₿/  ₿₿/       ₿₿/
=====================================================================

--]]

-- [[ Configure Core Settings]]

-- Load default Keymaps, Settings and Colorscheme
require("0xDmtri.core.set")
require("0xDmtri.core.remap")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy plugin manager
require("lazy").setup({

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Git related plugins
	{
		"NeogitOrg/neogit",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},

	-- Additional lua configuration, makes nvim stuff amazing!
	{ "folke/neodev.nvim" },

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Useful status updates for LSP
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup({})
				end,
			},

			-- Plugin to download remote lsp servers
			{ "williamboman/mason.nvim", config = true },

			-- Plugin to add mason lsp into lspconfig
			{ "williamboman/mason-lspconfig.nvim" },

			-- Rust dev env
			{
				"mrcjkb/rustaceanvim",
				version = "^5",
				lazy = false,
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				ft = { "rust" },
			},

			-- LSP extention for formatting
			{ "stevearc/conform.nvim" },

			-- LSP extention for linting
			{ "mfussenegger/nvim-lint" },

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				event = "InsertEnter",
				dependencies = {
					"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
					"hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
					"hrsh7th/cmp-path", -- Path source for nvim-cmp
					"L3MON4D3/LuaSnip", -- Snippet engine
					"saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
					"onsails/lspkind.nvim", -- Better completion UI
				},
			},

			-- VSCode style snippets
			{ "rafamadriz/friendly-snippets" },

			-- LSP Enhance Plugin
			{
				"nvimdev/lspsaga.nvim",
				name = "lspsaga",
				event = "LspAttach",
				dependencies = {
					"nvim-tree/nvim-web-devicons",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function()
					require("0xDmtri.configs.saga")
				end,
			},
		},
		-- Apply config
		config = function()
			require("0xDmtri.configs.lsp")
		end,
	},

	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		opts = {},
	},

	-- Adds git releated signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = function()
			return require("0xDmtri.configs.others").rose_pine
		end,
		config = function(_, opts)
			require("rose-pine").setup(opts)
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	-- Set lualine as statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "ColorScheme",
		opts = function()
			return require("0xDmtri.configs.others").lualine
		end,
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},

	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = function()
			return require("0xDmtri.configs.others").ibl
		end,
		config = function(_, opts)
			require("ibl").setup(opts)
		end,
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("0xDmtri.configs.telescope")
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("0xDmtri.configs.treesitter")
		end,
	},

	-- Crates helper
	{
		"saecki/crates.nvim",
		name = "crates",
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("0xDmtri.configs.crates")
		end,
	},

	-- Python env selector
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("0xDmtri.configs.venv")
		end,
	},

	-- Auto matching brackers
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Better file tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("0xDmtri.configs.neotree")
		end,
	},

	-- File bookmarks
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("0xDmtri.configs.harpoon")
		end,
	},

	-- Transparent windows on demand
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("0xDmtri.configs.transp")
		end,
	},

	-- Context functions while scrolling
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("treesitter-context").setup({})
		end,
	},

	-- Huff syntax highlighting
	{ "mouseless0x/vim-huff", lazy = false },
}, {})
