-- [[ Configure Venv Selector ]]

require("venv-selector").setup({})

vim.keymap.set({ "n", "t" }, ",v", "<cmd>VenvSelect<cr>")
