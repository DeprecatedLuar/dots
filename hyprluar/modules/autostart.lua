-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("~/.config/hypr/scripts/clipboard-notify-daemon.sh")

    hl.exec_cmd("mpv ~/.config/hypr/sounds/startup-sound-fast.mp3")
    hl.exec_cmd("ydotoold")
--    hl.exec_cmd("ambxst")
    hl.exec_cmd("sleep 5 && systemctl --user restart xdg-desktop-portal")
    -- hl.exec_cmd("noctalia")
    -- hl.exec_cmd("ambxst")
    -- hl.exec_cmd("~/.config/nwg-wrapper/quotes/quotes.sh")
    -- hl.exec_cmd("sleep 4 && kbstart")
end)
