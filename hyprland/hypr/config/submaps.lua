-- submaps, sway's modes from sway/sway/config.d/mode.conf and gaps.conf
local mod = "SUPER"

local function leave()
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end

-- system: (s)uspend, (r)eboot, (l)ock, (Shift+s)hutdown.
-- "reset" leaves the submap after any of them.
hl.bind(mod .. " + 0", hl.dsp.submap("system"))
hl.define_submap("system", "reset", function()
    hl.bind("S", hl.dsp.exec_cmd("systemctl suspend"))
    hl.bind("R", hl.dsp.exec_cmd("systemctl reboot"))
    hl.bind("L", hl.dsp.exec_cmd(NOCTALIA .. "session lock"))
    hl.bind("SHIFT + S", hl.dsp.exec_cmd("systemctl poweroff"))
    leave()
end)

-- resize: j/; shrink/grow width, k/l grow/shrink height, arrows in bigger steps
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    local function resize(x, y)
        return hl.dsp.window.resize({ x = x, y = y, relative = true })
    end
    hl.bind("J", resize(-20, 0), { repeating = true })
    hl.bind("K", resize(0, 20), { repeating = true })
    hl.bind("L", resize(0, -20), { repeating = true })
    hl.bind("semicolon", resize(20, 0), { repeating = true })
    hl.bind("Left", resize(-40, 0), { repeating = true })
    hl.bind("Down", resize(0, 40), { repeating = true })
    hl.bind("Up", resize(0, -40), { repeating = true })
    hl.bind("Right", resize(40, 0), { repeating = true })
    leave()
end)

-- gaps: (o)uter or (i)nner, then + / - / 0. hyprland gaps are global, so
-- sway's local and Shift (global) variants do the same thing here.
local function gaps(kind, delta)
    return function()
        if kind == "inner" then
            GAPS_IN = delta == 0 and 0 or math.max(0, GAPS_IN + delta)
        else
            GAPS_OUT = delta == 0 and 0 or math.max(0, GAPS_OUT + delta)
        end
        hl.config({ general = { gaps_in = GAPS_IN, gaps_out = GAPS_OUT } })
    end
end

hl.bind(mod .. " + SHIFT + G", hl.dsp.submap("gaps"))
hl.define_submap("gaps", function()
    hl.bind("O", hl.dsp.submap("gaps-outer"))
    hl.bind("I", hl.dsp.submap("gaps-inner"))
    leave()
end)

for _, kind in ipairs({ "inner", "outer" }) do
    hl.define_submap("gaps-" .. kind, function()
        for _, mods in ipairs({ "", "SHIFT + " }) do
            hl.bind(mods .. "equal", gaps(kind, 5), { repeating = true })
            hl.bind(mods .. "plus", gaps(kind, 5), { repeating = true })
            hl.bind(mods .. "minus", gaps(kind, -5), { repeating = true })
            hl.bind(mods .. "0", gaps(kind, 0))
        end
        leave()
    end)
end
