-- curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- springs for what moves (windows, workspaces), short beziers for what fades.

-- beziers
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })

-- springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 500, dampening = 35 })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 200, dampening = 15 })
-- a touch of bounce when a window appears, none when it moves
hl.curve("pop", { type = "spring", mass = 1, stiffness = 420, dampening = 26 })

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "quick" })

-- windows pop in from 85 % and shrink away, and glide when they move
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, spring = "pop", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, spring = "easy", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3, bezier = "almostLinear" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 3, bezier = "almostLinear" })

-- focus changes blend the border colors, and a gradient border (simorgh's)
-- turns once into place
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "easeOutQuint", style = "once" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 4, spring = "easy", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2, bezier = "quick", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "quick", style = "slidevert" })
