hl.window_rule({ match = { class = "thunderbird" },             workspace = "special:mail" })

-- Calendar reminders are delivered as swaync notifications and the reminder
-- dialog is disabled (calendar.notifications.* / calendar.alarms.show=false,
-- set in the Thunderbird profile via home-manager). This is a safeguard: if the
-- dialog ("<n> Reminder(s)") ever reappears (e.g. missed reminders), keep it
-- parked on special:mail without stealing focus or dragging the workspace over.
hl.window_rule({
    match          = { class = "thunderbird", title = "^[0-9]+ Reminders?$" },
    workspace      = "special:mail silent",
    suppress_event = "activate activatefocus",
})

hl.window_rule({ match = { class = "slack" },                   workspace = "special:slack" })
hl.window_rule({ match = { class = "zen-beta" }, workspace = "1" })

-- Floating utility windows
hl.window_rule({ match = { class = ".*pavucontrol.*" },      float = true, size = "800 500" })
hl.window_rule({ match = { class = "qpwgraph" },             float = true, size = "900 600" })
hl.window_rule({ match = { class = ".*blueman.*" },          float = true, size = "600 400" })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
