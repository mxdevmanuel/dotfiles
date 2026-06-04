local c = require("catppuccin-mocha")

--------------------
---- MONITORS ----
--------------------

-- Layout (left to right): eDP-1 | DP-3 | DP-4
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0",    scale = 1.5 })
hl.monitor({ output = "DP-3",  mode = "1920x1080@60", position = "1280x0", scale = 1 })
hl.monitor({ output = "DP-4",  mode = "1920x1080@60", position = "3200x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.workspace_rule({ workspace = 3,  monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = 6,  monitor = "eDP-1" })
hl.workspace_rule({ workspace = 9,  monitor = "eDP-1" })
hl.workspace_rule({ workspace = 2,  monitor = "DP-3",  default = true })
hl.workspace_rule({ workspace = 4,  monitor = "DP-3" })
hl.workspace_rule({ workspace = 8,  monitor = "DP-3" })
hl.workspace_rule({ workspace = 1,  monitor = "DP-4",  default = true })
hl.workspace_rule({ workspace = 5,  monitor = "DP-4" })
hl.workspace_rule({ workspace = 7,  monitor = "DP-4" })
hl.workspace_rule({ workspace = 10, monitor = "DP-4" })

--------------------
---- PROGRAMS ----
--------------------

local terminal    = "foot"
local fileManager = "thunar"
local menu        = "walker"

--------------------
---- AUTOSTART ----
--------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland && systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("systemctl --user enable --now hyprpolkitagent.service")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("quickshell -n")
end)

------------------------------
---- ENVIRONMENT VARIABLES ----
------------------------------

hl.env("XCURSOR_SIZE",        "24")
hl.env("HYPRCURSOR_SIZE",     "24")
hl.env("QT_QPA_PLATFORMTHEME","qt6ct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in      = 5,
        gaps_out     = 20,
        border_size  = 2,
        col = {
            active_border   = { colors = { "rgba(" .. c.mauveAlpha .. "ee)", "rgba(" .. c.blueAlpha .. "ee)" }, angle = 45 },
            inactive_border = "rgba(" .. c.overlay0Alpha .. "aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(" .. c.crustAlpha .. "ee)",
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        focus_on_activate       = true,
    },

    xwayland = { enabled = false },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-----------------
---- INPUT ----
-----------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "ctrl:nocaps",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({ name = "epic-mouse-v1",                 sensitivity = -0.5 })
hl.device({ name = "tpps/2-elan-trackpoint",        sensitivity = -0.7 })
hl.device({ name = "melfas-lgdisplay-incell-touch", enabled = false })

----------------------
---- KEYBINDINGS ----
----------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + C",         hl.dsp.window.close())
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + U",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T",         hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(menu .. " -m windows"))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -C"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.local/bin/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(menu .. " -m clipboard"))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))

-- Workspaces (1-10, key 0 maps to workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace / scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + G",         hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness (locked + repeating)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise --max-volume 100"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),                  { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),            { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("~/.local/bin/mic-mute.sh"),                              { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),                     { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),                     { locked = true, repeating = true })

-- Media (locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------
---- WINDOW RULES ----
--------------------------

hl.window_rule({
    name    = "suppress-maximize-events",
    match   = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({
    name      = "slack-workspace",
    match     = { class = "Slack" },
    workspace = 3,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
