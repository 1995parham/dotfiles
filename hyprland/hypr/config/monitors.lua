-- monitors: https://wiki.hypr.land/Configuring/Basics/Monitors/
-- list outputs with `hyprctl monitors`, add per machine rules in hosts/<hostname>.lua
hl.monitor({
    output   = MONITOR1,
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- kanshi's profiles (sway/kanshi/config), checked whenever a monitor comes or goes.
-- the laptop panel, hosts can extend it (x-wing turns on vrr) and call apply_monitor_profiles()
LAPTOP = {
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
}

-- at the nobitex desks the external monitor replaces the laptop panel
local DESKS = { "PA248QV", "PA248CRV" }
-- the AUT 201 class projector gets the focus workspace
local PROJECTOR = "PT-LB385"

local function find_monitor(model)
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name ~= LAPTOP.output and monitor.description:find(model, 1, true) then
            return monitor
        end
    end
end

function apply_monitor_profiles()
    local docked = false
    for _, model in ipairs(DESKS) do
        docked = docked or find_monitor(model) ~= nil
    end

    local laptop = { disabled = docked }
    for key, value in pairs(LAPTOP) do
        laptop[key] = value
    end
    hl.monitor(laptop)

    local projector = find_monitor(PROJECTOR)
    if projector then
        hl.dispatch(hl.dsp.workspace.move({ workspace = WORKSPACE_FOCUS, monitor = projector.name }))
    end
end

apply_monitor_profiles()
hl.on("monitor.added", apply_monitor_profiles)
hl.on("monitor.removed", apply_monitor_profiles)
