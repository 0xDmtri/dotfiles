-- [[ Configure Transparent ]]

local function setupTransparent()
	require("transparent").setup({
		extra_groups = {
			-- Normals
			"LspFloatWinNormal",
			"NormalFloat",
			"FloatBorder",

			-- GitSigns
			"GitSignsAdd",
			"GitSignsChange",
			"GitSignsDelete",

			-- Telescope
			"TelescopeNormal",
			"TelescopeBorder",

			-- LspSaga
			"SagaNormal",
			"SagaBorder",
		},
	})

	-- check if fidget installed
	local success, fidget = pcall(require, "fidget")

	-- if success pass blend to fidget accordingly
	if success then
		local opts = function()
			if vim.g.transparent_enabled then
				return { window = { winblend = 0 } }
			else
				return { window = { winblend = 100 } }
			end
		end

		fidget.setup({
			notification = opts(),
		})
	end
end

-- call to setup Transparent and Fidget (if installed)
setupTransparent()

-- Define the function that wrapps TransparentEnable with
-- transparent fidget borders
local function toggleLucid()
	-- check if fidget installed
	local success, fidget = pcall(require, "fidget")

	-- if success, make fidget transparent
	if success then
		fidget.setup({
			notification = {
				window = {
					winblend = 0,
				},
			},
		})
	end

	-- Then, execute the :TransparentEnable command
	vim.cmd("TransparentEnable")
end

-- Define the function that wrapps TransparentDisable with
-- transparent fidget borders
local function toggleSolid()
	-- check if fidget installed
	local success, fidget = pcall(require, "fidget")

	-- if success, make fidget solid
	if success then
		fidget.setup({
			notification = {
				window = {
					winblend = 100,
				},
			},
		})
	end

	-- Then, execute the :TransparentDisable command
	vim.cmd("TransparentDisable")
end

-- Create a new command that makes everything lucid
vim.api.nvim_create_user_command("Lucid", toggleLucid, {})

-- Create a new command that makes everything solid
vim.api.nvim_create_user_command("Solid", toggleSolid, {})
