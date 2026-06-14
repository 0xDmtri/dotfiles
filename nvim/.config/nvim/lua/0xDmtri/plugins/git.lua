-- [[ Git Integration ]]

return {
    {
        "NeogitOrg/neogit",
        branch = "master",
        cmd = "Neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "folke/snacks.nvim",
        },
        opts = {
            integrations = {
                diffview = true,
                snacks = true,
            },
            diff_viewer = "diffview",
        },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
    },

    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewClose",
            "DiffviewFileHistory",
            "DiffviewFocusFiles",
            "DiffviewOpen",
            "DiffviewRefresh",
            "DiffviewToggleFiles",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        opts = function()
            local actions = require("diffview.actions")

            return {
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = "diff2_horizontal",
                        disable_diagnostics = true,
                        winbar_info = true,
                    },
                    file_history = {
                        layout = "diff2_horizontal",
                        disable_diagnostics = true,
                        winbar_info = true,
                    },
                    merge_tool = {
                        layout = "diff3_horizontal",
                        disable_diagnostics = true,
                        winbar_info = true,
                    },
                },
                file_panel = {
                    listing_style = "tree",
                    win_config = {
                        position = "right",
                        width = 35,
                    },
                },
                file_history_panel = {
                    win_config = {
                        position = "bottom",
                        height = 16,
                    },
                },
                keymaps = {
                    disable_defaults = false,
                    view = {
                        { "n", "<leader>co", false },
                        { "n", "<leader>ct", false },
                        { "n", "<leader>cb", false },
                        { "n", "<leader>ca", false },
                        { "n", "<leader>cO", false },
                        { "n", "<leader>cT", false },
                        { "n", "<leader>cB", false },
                        { "n", "<leader>cA", false },
                        { "n", "<leader>xo", actions.conflict_choose("ours"), { desc = "Choose ours" } },
                        { "n", "<leader>xt", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
                        { "n", "<leader>xb", actions.conflict_choose("base"), { desc = "Choose base" } },
                        { "n", "<leader>xa", actions.conflict_choose("all"), { desc = "Choose all" } },
                        { "n", "<leader>xO", actions.conflict_choose_all("ours"), { desc = "Choose ours for file" } },
                        {
                            "n",
                            "<leader>xT",
                            actions.conflict_choose_all("theirs"),
                            { desc = "Choose theirs for file" },
                        },
                        { "n", "<leader>xB", actions.conflict_choose_all("base"), { desc = "Choose base for file" } },
                        { "n", "<leader>xA", actions.conflict_choose_all("all"), { desc = "Choose all for file" } },
                    },
                    file_panel = {
                        { "n", "<leader>cO", false },
                        { "n", "<leader>cT", false },
                        { "n", "<leader>cB", false },
                        { "n", "<leader>cA", false },
                        { "n", "<leader>xO", actions.conflict_choose_all("ours"), { desc = "Choose ours for file" } },
                        {
                            "n",
                            "<leader>xT",
                            actions.conflict_choose_all("theirs"),
                            { desc = "Choose theirs for file" },
                        },
                        { "n", "<leader>xB", actions.conflict_choose_all("base"), { desc = "Choose base for file" } },
                        { "n", "<leader>xA", actions.conflict_choose_all("all"), { desc = "Choose all for file" } },
                    },
                },
            }
        end,
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff changes" },
            { "<leader>gD", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diff working tree" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
            { "<leader>gf", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle diff files" },
            { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, "Next hunk")

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, "Previous hunk")

                map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk")
                map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
                map("v", "<leader>gs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk")
                map("v", "<leader>gr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk")
                map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
                map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
                map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Preview hunk inline")
                map("n", "<leader>gl", function()
                    gitsigns.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>gL", gitsigns.toggle_current_line_blame, "Toggle line blame")
            end,
        },
    },
}
