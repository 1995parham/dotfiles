-- workspaces: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- 1..9 carry sway's names, the 10th is sway's f:focus
for i, name in ipairs(WORKSPACES) do
    hl.workspace_rule({ workspace = tostring(i), default_name = name, monitor = MONITOR1 })
end
hl.workspace_rule({ workspace = WORKSPACE_FOCUS, monitor = MONITOR1 })

-- cachyos sends games here (windowrules.lua)
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR })

hl.config({
    binds = {
        -- sway's workspace_auto_back_and_forth yes
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        -- moving focus left/right walks through a group's tabs first, like
        -- sway's tabbed layout
        movefocus_cycles_groupfirst = true,
    },
})
