-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

-- This is where you actually apply your config choices
-- Spawn a fish shell in login mode
config.default_prog = { 'fish'}

config.font = wezterm.font 'Fira Code'
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = false })

-- For example, changing the color scheme:
config.color_scheme = 'Ayu Dark (Gogh)'

-- and finally, return the configuration to wezterm
return config

