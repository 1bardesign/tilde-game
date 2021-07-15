require("batteries"):export()

local game_state = state_machine({
	game = require("game_state")(),
	--todo: title, win
}, "game")

function love.update(dt)
	game_state:update(dt)
end

function love.draw()
	game_state:draw()
end

function love.keypressed(k)
	if love.keyboard.isDown("lctrl", "rctrl") then
		if k == "q" then
			love.event.quit()
		elseif k == "r" then
			love.event.quit("restart")
		end
	end

	game_state:_call("keypressed", k)
end
