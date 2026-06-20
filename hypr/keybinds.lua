local M = "SUPER"
local terminal    = "foot"
local fileManager = "nautilus"
local menu        = "wofi --show drun"
local browser     = "app.zen_browser.zen"

-- Apps
hl.bind(M .. " + Return",  hl.dsp.exec_cmd(terminal))
hl.bind(M .. " + Q",       hl.dsp.window.close())
hl.bind(M .. " + M",       hl.dsp.exit())
hl.bind(M .. " + F",       hl.dsp.window.fullscreen())
hl.bind(M .. " + N",       hl.dsp.exec_cmd(fileManager))
hl.bind(M .. " + D",       hl.dsp.exec_cmd(menu))
hl.bind(M .. " + Z",       hl.dsp.exec_cmd(browser))
hl.bind(M .. " + P",       hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind(M .. " + Escape",  hl.dsp.exec_cmd("hyprlock"))

-- Floating — like sway's $mod+Shift+Space / $mod+Space
hl.bind(M .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(M .. " + Space",         hl.dsp.window.cycle_next())

-- Split direction toggle — like sway's $mod+b
hl.bind(M .. " + B", hl.dsp.layout("togglesplit"))

-- Swap focused window with master
hl.bind(M .. " + SHIFT + Return", hl.dsp.layout("swapwithmaster"))

-- Launch or toggle special workspaces
hl.bind(M .. " + T", hl.dsp.exec_cmd(
    "pgrep thunderbird && hyprctl dispatch togglespecialworkspace mail || thunderbird &"))
hl.bind(M .. " + S", hl.dsp.exec_cmd(
    "pgrep slack && hyprctl dispatch togglespecialworkspace slack || slack &"))

-- Move focus — vim keys
hl.bind(M .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(M .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(M .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(M .. " + J", hl.dsp.focus({ direction = "d" }))

-- Move focus — arrow keys
hl.bind(M .. " + Left",  hl.dsp.focus({ direction = "l" }))
hl.bind(M .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(M .. " + Up",    hl.dsp.focus({ direction = "u" }))
hl.bind(M .. " + Down",  hl.dsp.focus({ direction = "d" }))

-- Move window — vim keys
hl.bind(M .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(M .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(M .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(M .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Move window — arrow keys (like sway's $mod+Shift+arrow)
hl.bind(M .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(M .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(M .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(M .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces
for i = 1, 9 do
    hl.bind(M .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(M .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(M .. " + 0",         hl.dsp.focus({ workspace = 10 }))
hl.bind(M .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll through workspaces
hl.bind(M .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { click = true })
hl.bind(M .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { click = true })

-- Resize mode — like sway's $mod+r
hl.bind(M .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("H",     hl.dsp.window.resize({ x = -20, y = 0   }), { repeating = true })
    hl.bind("L",     hl.dsp.window.resize({ x =  20, y = 0   }), { repeating = true })
    hl.bind("K",     hl.dsp.window.resize({ x =  0,  y = -20 }), { repeating = true })
    hl.bind("J",     hl.dsp.window.resize({ x =  0,  y =  20 }), { repeating = true })
    hl.bind("Left",  hl.dsp.window.resize({ x = -20, y = 0   }), { repeating = true })
    hl.bind("Right", hl.dsp.window.resize({ x =  20, y = 0   }), { repeating = true })
    hl.bind("Up",    hl.dsp.window.resize({ x =  0,  y = -20 }), { repeating = true })
    hl.bind("Down",  hl.dsp.window.resize({ x =  0,  y =  20 }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Mouse move/resize
hl.bind(M .. " + mouse:272", hl.dsp.window.drag(),   { drag = true })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { drag = true })
