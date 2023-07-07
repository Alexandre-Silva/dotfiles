local wezterm = require("wezterm")
local config = {}

-- my configs
--

config.font = wezterm.font_with_fallback({
	"Inconsolata Nerd Font Mono",
	"Inconsolata",
	"Symbols Nerd Font Mono",
	{ family = "Inconsolata LGC Nerd Font Mono", style = "Italic" },
	"Fire Mono",
})
-- config.font_rules = _
_ = {
	{
		-- intensity = 'Normal',
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			-- family = "Inconsolata Nerd Font Mono",
			-- family = "Inconsolata LGC Nerd Font Mono",
			-- family = "Inconsolata LGC Nerd Font Propo",
			family = "InconsolataGO Nerd Font Mono",
			-- family = "InconsolataGO Nerd Font",

			-- weight = "DemiLight",
			-- weight = "Book",
			-- weight = "Regular",
			-- weight = 'Medium',
			-- weight = "Light",

			-- stretch = "ExtraCondensed",
			-- stretch = "Condensed",
			-- stretch = "SemiCondensed",
			-- stretch = "Normal",
      -- stretch = "Expanded",
      -- stretch = "UltraExpanded",

			style = "Italic",
			-- style = "Oblique",

-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
		}),
	},
}
config.font_size = 11.0
config.dpi = 163
-- config.warn

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "nord"
-- config.colors = {
-- 	cursor_fg = "yellow",
-- 	background = "blue",
-- }

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
