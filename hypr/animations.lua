hl.config({ animations = { enabled = true } })

hl.curve("overshot", { type = "bezier", points = { { 0, 0.61 }, { 0.22, 1.12 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 3,   bezier = "default", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,   bezier = "overshot" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3,   bezier = "default", style = "popin" })
hl.animation({ leaf = "border",      enabled = true, speed = 1,   bezier = "default" })
hl.animation({ leaf = "fadeIn",      enabled = true, speed = 5,   bezier = "default" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 5,   bezier = "default" })
hl.animation({ leaf = "fadeSwitch",  enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3.8, bezier = "overshot", style = "slidevert" })
hl.animation({ leaf = "border",      enabled = true, speed = 10,  bezier = "overshot" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 50,  bezier = "overshot", style = "loop" })
