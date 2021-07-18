function love.conf(t)
	local name = "forest"

	t.version = "11.3"

	t.window.title = name
	t.identity = name
	-- t.window.icon = "assets/icon.png"

	-- commandline output for windows
	t.console = true

	--720p window for now
	t.window.width = 1280
	t.window.height = 720
end
