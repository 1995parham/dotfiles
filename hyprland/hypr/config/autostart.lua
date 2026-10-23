-- autostart: cachyos' session bits plus sway's workspaces.service
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")

    -- daily workspace setup (sway/services/workspaces.service), skipping what
    -- this machine does not have
    hl.exec_cmd(LAUNCH .. TERMINAL, { workspace = "1 silent" })
    hl.exec_cmd(
        "command -v google-chrome-stable >/dev/null && " .. LAUNCH .. "google-chrome-stable",
        { workspace = "4 silent" }
    )
    hl.exec_cmd("command -v obsidian >/dev/null && " .. LAUNCH .. "obsidian", { workspace = "3 silent" })
    hl.dispatch(hl.dsp.focus({ workspace = WORKSPACE_FOCUS }))
end)
