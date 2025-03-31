-- [[ Configure Harpoon ]]

local wk = require("which-key")
local harpoon = require("harpoon")

harpoon:setup({})

-- Define the base mappings table
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

-- Generate select mappings for files 1 through 4 using a loop
for i = 1, 4 do
    table.insert(harpoon_mappings, {
        "<leader>h" .. i,
        function()
            harpoon:list():select(i)
        end,
        desc = "File [" .. i .. "]",
    })
end

-- Add the cycle mapping
table.insert(harpoon_mappings, {
    "<M-tab>",
    function()
        harpoon:list():next({ ui_nav_wrap = true })
    end,
    desc = "which_key_ignore",
})

-- Register all mappings with Which-Key
wk.add(harpoon_mappings)
