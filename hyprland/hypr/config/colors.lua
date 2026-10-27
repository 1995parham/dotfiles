-- sway theme colors (client.focused / client.unfocused), the orange of the
-- noctalia bars (../../noctalia/bar.toml)
ORANGE = "rgba(ffa500ff)"
GRAY = "rgba(333333ff)"
DARK = "rgba(111111ff)"
LIGHT = "rgba(fdf6e3ff)"
RED = "rgba(b30000ff)"
BLUE = "rgba(268bd2ff)"

-- the same color at another alpha: alpha(ORANGE, "30")
function alpha(color, a)
    return (color:gsub("^rgba%((%x%x%x%x%x%x)%x%x%)$", "rgba(%1" .. a .. ")"))
end
