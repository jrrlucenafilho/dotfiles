-- See https://wiki.hyprland.org/Configuring/Binds/

--Edit shell config
hl.bind(
	"CTRL+SUPER+Slash",
	hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json"),
	{ description = "Edit shell config" }
)
-- Edit extra keybinds
hl.bind(
	"CTRL+SUPER+ALT+Slash",
	hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"),
	{ description = "Edit user keybinds" }
)

-- Add stuff here
-- Add a comment after a bind to add a description, like above

-- Graphic tablet toggle
hl.bind(
	"CTRL+SUPER+O",
	hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/toggle_tablet_active_area.sh"),
	{ description = "Toggle Graphic Tablet mode" }
)

-- Open vscode
hl.bind("SUPER+ALT+C", hl.dsp.exec_cmd("code"), { description = "Open VScode" })

-- end4-pC fork settings
hl.bind("SUPER + escape", hl.dsp.global("quickshell:settingsToggle"), {description = "Toggle settings"})
