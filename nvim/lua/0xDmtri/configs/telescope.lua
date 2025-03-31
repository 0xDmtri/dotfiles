-- [[ Configure Telescope ]]

-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
})

-- Enable telescope fzf native
require("telescope").load_extension("fzf")

-- Enable harpoon
require("telescope").load_extension("harpoon")

local builtin = require("telescope.builtin")

require("which-key").add({
    { "<leader>s", group = "+Search" },
    { "<leader>sG", builtin.git_files, desc = "Git Files" },
    { "<leader>sf", builtin.find_files, desc = "Files" },
    { "<leader>sh", builtin.help_tags, desc = "Help Tags" },
    { "<leader>sw", builtin.grep_string, desc = "Word" },
    { "<leader>sg", builtin.live_grep, desc = "Grep" },
})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })
