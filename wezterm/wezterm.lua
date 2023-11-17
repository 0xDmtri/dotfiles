-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Window padding
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 0,
}

-- Move tab bar to the bottom
config.tab_bar_at_bottom = true

-- Set Hack Nerd Font at main font
config.font = wezterm.font 'Hack Nerd Font'

-- Disable dead keys
config.use_dead_keys = false

-- This is where you actually apply your config choices
config.window_background_opacity = 0.8

-- For example, changing the color scheme:
config.color_scheme = 'rose-pine'

-- and finally, return the configuration to wezterm
return config
