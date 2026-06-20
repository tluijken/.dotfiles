hl.config({ animations = { enabled = true } })

hl.curve("spring", { type = "bezier", points = { { 0.155, 1.105 }, { 0.22, 1.12 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })

-- Windows open/close with a scale effect, feel springy when moved
hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "spring", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "spring" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "smooth", style = "popin 80%" })

-- Fades
hl.animation({ leaf = "fadeIn",     enabled = true, speed = 5, bezier = "smooth" })
hl.animation({ leaf = "fadeOut",    enabled = true, speed = 5, bezier = "smooth" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 8, bezier = "smooth" })
hl.animation({ leaf = "fadeDim",    enabled = true, speed = 5, bezier = "smooth" })

-- Workspaces slide horizontally with a spring
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "spring", style = "slide" })

-- Border fades in smoothly, no spinning rainbow loop
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "smooth" })
