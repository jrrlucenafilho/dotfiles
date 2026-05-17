-- You can put custom rules here
-- Window/layer rules: https://wiki.hyprland.org/Configuring/Window-Rules/
-- Workspace rules: https://wiki.hyprland.org/Configuring/Workspace-Rules/

-- Floating programs
hl.window_rule({
	name = "qalculate-float",
	match = { class = "io.github.Qalculate.qalculate-qt" },
	float = true,
})

hl.window_rule({
	name = "gwenview-float",
	match = { class = "org.kde.gwenview" },
	float = true,
})

hl.window_rule({
	name = "pomodorolm-float",
	match = { class = "pomodorolm" },
	float = true,
})

hl.window_rule({
	name = "pomodorolm-move",
	match = { class = "pomodorolm" },
	move = "monitor_w-window_w-20 monitor_h-window_h-20",
})

hl.window_rule({
	name = "pupgui2-float",
	match = { class = "net.davidotok.pupgui2" },
	float = true,
})

-- Enable blur for every window
hl.window_rule({
	name = "blur-on",
	match = { class = ".*" },
	no_blur = false,
})

-- Translucency for programs
hl.window_rule({
	name = "neovide-opacity",
	match = { class = "neovide" },
	opacity = "0.90 0.85",
})

hl.window_rule({
	name = "zed-opacity",
	match = { class = "dev.zed.Zed" },
	opacity = "0.90 0.85",
})

hl.window_rule({
	name = "code-opacity",
	match = { class = "code" },
	opacity = "0.90 0.85",
})

hl.window_rule({
	name = "vesktop-opacity",
	match = { class = "vesktop" },
	opacity = "0.90 0.85",
})

hl.window_rule({
	name = "dolphin-opacity",
	match = { class = "org.kde.dolphin" },
	opacity = "0.90 0.85",
})

hl.window_rule({
	name = "whatsie-opacity",
	match = { class = "com.ktechpit.whatsie" },
	opacity = "0.90 0.85",
})

-- Assign workspaces 1-5 to monitor 1
for i = 1, 5 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "eDP-1",
		default = true,
	})
end

-- Assign workspaces 6-10 to monitor 2
for i = 6, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "HDMI-A-1",
		default = true,
	})
end
