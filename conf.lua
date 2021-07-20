function love.conf(t)
	t.version = "11.3"

	t.window.title = "~"
	t.identity = "tilde"
	t.window.icon = "assets/icon.png"

	-- commandline output for windows
	t.console = false

	local windowed = false
	if windowed then
		t.window.width = 1280
		t.window.height = 720
	else
		t.window.fullscreen = "desktop"
	end
end
