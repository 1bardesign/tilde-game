require("batteries"):export()

local state = state_machine({
	game = require("game_state")(),
	--todo: title, win
}, "game")

function love.update(dt)
	state:update(dt)
end

function love.draw()
	state:draw()
end

function love.keypressed(k)
	if love.keyboard.isDown("lctrl", "rctrl") then
		if k == "q" then
			love.event.quit()
		elseif k == "r" then
			love.event.quit("restart")
		end
	end

	state:_call("keypressed", k)
end
