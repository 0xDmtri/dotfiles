-- [[ Git Integration ]]

return {
    {
        "NeogitOrg/neogit",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        config = true,
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
        },
    },
}
