local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Noto Sans Mono CJK JP",
		"Source Han Sans",
	}),
	font_size = 12,
}

config.window_background_opacity = 1.00
config.check_for_updates = false

config.keys = {
	{
		key = "f",
		mods = "SHIFT|META",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "t",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "d",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "¥",
		mods = "OPT",
		action = wezterm.action({ SendString = "\\" }),
	},
	-- {
	--   key='c',
	--   mods='CTRL',
	--   action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
	-- },
	{
		key = "LeftArrow",
		mods = "SHIFT|CTRL",
		action = wezterm.action({ ActivateTabRelative = -1 }),
	},
	{
		key = "RightArrow",
		mods = "SHIFT|CTRL",
		action = wezterm.action({ ActivateTabRelative = 1 }),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
