-- Put general config stuff here
-- Here's a list of every variable: https://wiki.hyprland.org/Configuring/Variables

----- [[ Monitor Configs]] -----
-- Main monitor config
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = "1"
})

-- Secondary HDMI monitor
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@100.00Hz",
    position = "-1920x0@100.00Hz",
    scale = "1"
})

----- [[ Misc configs ]] -----
-- Keyboard layout
hl.config({
    input = {
        kb_layout = "br",
        kb_variant = "abnt2",
        accel_profile = "flat",
        tablet = {
            transform = 1 -- 90 degrees clockwise
        }
    },
    general = {
        allow_tearing = true
    }
})

-- Overwrite original config's blur
hl.config({
    decoration = {
        blur = {
            enabled = true,
            xray = true,
            special = false,
            new_optimizations = true,
            size = 10,
            passes = 3,
            brightness = 1,
            noise = 0.0117,
            contrast = 0.8916,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.5,
            popups = false,
            popups_ignorealpha = 0.6,
            input_methods = true,
            input_methods_ignorealpha = 0.8
        }
    }
})
