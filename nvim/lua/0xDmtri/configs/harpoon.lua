-- [[ Configure Harpoon ]]

local wk = require("which-key")
local harpoon = require("harpoon")

harpoon:setup({})

wk.add({
	{ "<leader>h", group = "harpoon" },
	{
		"<leader>ha",
		function()
			harpoon:list():add()
		end,
		desc = "[H]arpoon [A]dd buffer",
		mode = "n",
	},
	{
		"<leader>hm",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "[H]arpoon [M]enu",
		mode = "n",
	},
	{
		"<leader>h1",
		function()
			harpoon:list():select(1)
		end,
		desc = "[H]arpoon file [1]",
		mode = "n",
	},
	{
		"<leader>h2",
		function()
			harpoon:list():select(2)
		end,
		desc = "[H]arpoon file [2]",
		mode = "n",
	},
	{
		"<leader>h3",
		function()
			harpoon:list():select(3)
		end,
		desc = "[H]arpoon file [3]",
		mode = "n",
	},
	{
		"<leader>h4",
		function()
			harpoon:list():select(4)
		end,
		desc = "[H]arpoon file [4]",
		mode = "n",
	},
	{
		"<M-tab>",
		function()
			harpoon:list():next()
		end,
		desc = "which_key_ignore",
		mode = "n",
	},
})
