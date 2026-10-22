hl.config({
    input = {
        follow_mouse = 0,
    },
})

-- Compositor-side cursor lock for fullscreen games
hl.window_rule({
    name  = "confine-pointer-games",
    match = { content = "game", fullscreen = true },
    confine_pointer = true,
})
