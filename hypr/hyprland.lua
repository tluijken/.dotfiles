-- #env = AQ_DRM_DEVICES,/dev/dri/by-path/pci-0000:01:00.0-card:/dev/dri/by-path/pci-0000:00:02.0-card
-- #env = LIBVA_DRIVER_NAME,nvidia
-- #env = __GLX_VENDOR_LIBRARY_NAME,nvidia
-- #env = NVD_BACKEND,direct

hl.monitor({ output = "DP-3",  mode = "3840x2160@60",  position = "0x0",    scale = 1.25 })
hl.monitor({ output = "DP-1",  mode = "3840x2160@60",  position = "2560x0", scale = 1.0  })
hl.monitor({ output = "eDP-1", mode = "3840x2400@60",  position = "0x0",    scale = 1.5  })

local home = os.getenv("HOME")
dofile(home .. "/.dotfiles/hypr/env.lua")
dofile(home .. "/.dotfiles/hypr/animations.lua")
dofile(home .. "/.dotfiles/hypr/keybinds.lua")
dofile(home .. "/.dotfiles/hypr/windrules.lua")
dofile(home .. "/.dotfiles/hypr/autostart.lua")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    input = {
        kb_layout   = "us",
        kb_variant  = "intl",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 1,
        col = {
            active_border   = "rgba(89b4faFF)",
            inactive_border = "rgba(31324411)",
        },
        resize_on_border = false,
        layout           = "master",
        allow_tearing    = false,
    },
    decoration = {
        rounding         = 14,
        dim_inactive     = true,
        dim_strength     = 0.1,
        active_opacity   = 0.99,
        inactive_opacity = 0.85,
        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            noise             = 0.02,
            contrast          = 1.0,
            brightness        = 1.0,
        },
        shadow = {
            enabled        = true,
            range          = 12,
            render_power   = 4,
            color          = "rgba(89b4fa28)",
            color_inactive = "rgba(00000000)",
        },
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
