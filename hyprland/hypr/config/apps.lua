-- per application rules, sway/sway/config.d/apps.conf translated.
-- find classes and titles with `hyprctl clients`.
local function size(w, h)
    return { "monitor_w*" .. w, "monitor_h*" .. h }
end

-- the floating terminal in the middle of the screen
hl.window_rule({ match = { class = "^(__termpad)$" }, float = true, center = true, size = size(0.6, 0.6) })

hl.window_rule({
    match = { class = "^(org\\.telegram\\.desktop|Telegram)$" },
    workspace = "4 silent",
    float = true,
    size = size(0.25, 0.75),
})
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { class = "^([Vv]irt-manager)$" }, workspace = "5 silent" })
hl.window_rule({
    match = { class = "^(WebCord)$" },
    workspace = "8 silent",
    float = true,
    size = size(0.4, 0.7),
    move = { "0", "monitor_h*0.1" },
})
hl.window_rule({
    match = { class = "^([Ss]lack)$" },
    workspace = "7 silent",
    float = true,
    size = size(0.6, 0.7),
    move = { "monitor_w*0.4", "monitor_h*0.1" },
})
hl.window_rule({ match = { class = "^(me\\.parham1995\\.notes)$" }, workspace = "3 silent" })
hl.window_rule({ match = { class = "^([Cc]ode|[Cc]ode - Insiders|code-insiders)$" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "^(google-chrome.*)$" }, workspace = "4 silent" })
hl.window_rule({ match = { class = "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$" }, float = true })
hl.window_rule({
    match = { class = "^(GalaxyBudsClient)$" },
    float = true,
    size = size(0.6, 0.7),
    opacity = "0.9",
    border_size = 0,
})
hl.window_rule({ match = { class = "^(30nama)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { title = "^(Sniffnet)$" }, float = true })
