-- [[ Setting options ]]

-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable line wrap
vim.opt.wrap = false

-- Set highlight on search
vim.o.hlsearch = false

-- Enable automatic indentation
vim.o.autoindent = true

-- Enable syntax-aware indentation
vim.o.smartindent = true

-- Convert tabs to spaces
vim.o.expandtab = true

-- Make relative numbers
vim.wo.relativenumber = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Make default split below
vim.opt.splitbelow = true

-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 150
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Disable neovim builtin diagnostic virtual text
-- and enable serverity sort
vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
})

-- Python Neovim plugin
vim.g.python3_host_prog = "/Users/dmtri/.pyenv/versions/nvim/bin/python"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})
