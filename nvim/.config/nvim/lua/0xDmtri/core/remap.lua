-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- ctrl + h,j,k,l for insert mode
vim.keymap.set("i", "<C-h>", "<left>")
vim.keymap.set("i", "<C-j>", "<down>")
vim.keymap.set("i", "<C-k>", "<up>")
vim.keymap.set("i", "<C-l>", "<right>")

-- ctrl + h,j,k,l for window navigation in terminal mode
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>")
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>")
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>")

-- Disable default keymaps
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gO")
vim.keymap.del("i", "<C-S>")
