-- per application rules, sway/sway/config.d/apps.conf translated.
-- find classes and titles with `hyprctl clients`.
-- this file loads after windowrules.lua and the last matching rule wins, so
-- what is set here overrides cachyos' rules for the same window.
local function size(w, h)
    return { "monitor_w*" .. w, "monitor_h*" .. h }
end

-- the workspace an app opens on, by its name in WORKSPACES (variables.lua),
-- so a renamed or reordered workspace does not strand its apps. silent opens
-- it there without following it.
local function home(name, silent)
    for i, ws in ipairs(WORKSPACES) do
        if ws == name then
            return tostring(i) .. (silent and " silent" or "")
        end
    end
    error("apps.lua: no workspace named " .. name)
end

-- the floating terminal in the middle of the screen
hl.window_rule({ match = { class = "^(__termpad)$" }, float = true, center = true, size = size(0.6, 0.6) })

---------------
---- HOMES ----
---------------
hl.window_rule({ match = { class = "^(firefox)$" }, workspace = home("www") })
hl.window_rule({ match = { class = "^(google-chrome.*)$" }, workspace = home("www", true) })
hl.window_rule({ match = { class = "^([Cc]ode|[Cc]ode - Insiders|code-insiders)$" }, workspace = home("main-2", true) })
hl.window_rule({ match = { class = "^(me\\.parham1995\\.notes)$" }, workspace = home("notes", true) })
hl.window_rule({ match = { class = "^([Vv]irt-manager)$" }, workspace = home("vm", true) })

-- chat: telegram, element (matrix) and slack on social-1, discord on social-2
hl.window_rule({
    match = { class = "^(org\\.telegram\\.desktop|Telegram|TelegramDesktop)$" },
    workspace = home("social-1", true),
    float = true,
    size = size(0.25, 0.75),
})
hl.window_rule({
    match = { class = "^([Ss]lack)$" },
    workspace = home("social-1", true),
    float = true,
    size = size(0.6, 0.7),
    move = { "monitor_w*0.4", "monitor_h*0.1" },
})
hl.window_rule({ match = { class = "^(Element)$" }, workspace = home("social-1", true) })
hl.window_rule({
    match = { class = "^(WebCord)$" },
    workspace = home("social-2", true),
    float = true,
    size = size(0.4, 0.7),
    move = { "0", "monitor_h*0.1" },
})

------------------
---- FLOATING ----
------------------
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$" }, float = true })
hl.window_rule({ match = { title = "^(Sniffnet)$" }, float = true })
hl.window_rule({
    match = { class = "^(GalaxyBudsClient)$" },
    float = true,
    size = size(0.6, 0.7),
    opacity = "0.9",
    border_size = 0,
})
-- cachyos' own tools (hello, kernel and scx managers, shelly, btrfs
-- assistant) and the image viewer are dialogs, not workspaces
hl.window_rule({
    match = {
        class = "^(org\\.cachyos\\..*|cachyos-.*|scx-manager|btrfs-assistant|com\\.shellyorg\\.shelly.*|shelly-ui)$",
    },
    float = true,
    center = true,
    size = size(0.6, 0.7),
})
hl.window_rule({ match = { class = "^(qview|com\\.interversehq\\.qView)$" }, float = true, center = true })

-----------------
---- SECRETS ----
-----------------
-- password prompts: gpg-agent's pinentry-gnome3 and the ssh passphrase both
-- end in the keyring's gcr-prompter, pinentry-qt is the fallback. they open in
-- the middle, keep the keyboard until answered, and stay black in a screen
-- share; so does polkit's prompt.
hl.window_rule({
    name = "password-prompts",
    match = { class = "^(gcr-prompter|[Pp]inentry-.*|org\\.gnupg\\.pinentry-.*)$" },
    float = true,
    center = true,
    stay_focused = true,
    dim_around = true,
    no_screen_share = true,
})
hl.window_rule({ match = { title = "^(Authentication Required)$" }, no_screen_share = true })

--------------
---- IDLE ----
--------------
-- no dim, lock or screen off (noctalia's idle.toml) while something is
-- fullscreen: a film, a call, slides. 30nama keeps it awake while focused.
hl.window_rule({ name = "idle-fullscreen", match = { class = ".*" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(30nama)$" }, idle_inhibit = "focus" })
