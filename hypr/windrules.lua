hl.window_rule({ match = { class = "thunderbird" },             workspace = "special:mail" })
hl.window_rule({ match = { class = "Slack" },                   workspace = "special:slack" })
hl.window_rule({ match = { class = "app\\.zen_browser\\.zen" }, workspace = "1" })

-- Floating utility windows
hl.window_rule({ match = { class = "pavucontrol" },          float = true, size = "800 500" })
hl.window_rule({ match = { class = "qpwgraph" },             float = true, size = "900 600" })
hl.window_rule({ match = { class = "blueman-manager" },      float = true, size = "600 400" })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
