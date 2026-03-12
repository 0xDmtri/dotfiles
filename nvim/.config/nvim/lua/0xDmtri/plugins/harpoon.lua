-- [[ File Bookmarks ]]

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local wk = require("which-key")
        local harpoon = require("harpoon")

        harpoon:setup({})

        local harpoon_mappings = {
            { "<leader>h", group = "+Harpoon" },
            {
                "<leader>ha",
                function()
                    harpoon:list():add()
                end,
                desc = "Add buffer",
            },
            {
                "<leader>hm",
                function()
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Menu",
            },
        }

        for i = 1, 4 do
            table.insert(harpoon_mappings, {
                "<leader>h" .. i,
                function()
                    harpoon:list():select(i)
                end,
                desc = "File [" .. i .. "]",
            })
        end

        table.insert(harpoon_mappings, {
            "<M-tab>",
            function()
                harpoon:list():next({ ui_nav_wrap = true })
            end,
            desc = "which_key_ignore",
        })

        wk.add(harpoon_mappings)
    end,
}
