function love.conf(t)
	local name = "~"

	t.version = "11.3"

	t.window.title = name
	t.identity = name
	t.window.icon = "raw/icon.png"

	-- commandline output for windows
	t.console = true

	t.window.fullscreen = "desktop"
end
