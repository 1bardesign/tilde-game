require("batteries"):export()

local game_state = state_machine({
	game = require("game_state")(),
	title = require("title_state")(),
	--todo: title, win
}, "title")

love.keyboard.setKeyRepeat(true)

local times = {}

function love.update(dt)
	times = {}

	table.insert(times, "update")
	table.insert(times, love.timer.getTime())
	game_state:update(dt)
	table.insert(times, love.timer.getTime())
end

function love.draw()
	table.insert(times, "draw")
	table.insert(times, love.timer.getTime())
	game_state:draw()
	table.insert(times, love.timer.getTime())

	if love.keyboard.isDown("`") then
		love.graphics.push()
		love.graphics.translate(10, 10)
		local stats = love.graphics.getStats()
		for _, v in ipairs({
			("fps: %d"):format(love.timer.getFPS()),
			("vram: %dmb"):format(stats.texturememory / 1024 / 1024),
			("drawcalls: %d (%d auto-batched)"):format(stats.drawcalls, stats.drawcallsbatched),
		}) do
			love.graphics.print(v)
			love.graphics.translate(0, 15)
		end
		for i = 1, #times, 3 do
			local name = times[i]
			local start = times[i+1]
			local finish = times[i+2]
			love.graphics.print(("%s %0.3fms"):format(name, (finish - start) * 1000))
			love.graphics.translate(0, 15)
		end
		love.graphics.pop()
	end
end

function love.keypressed(k,_,isrepeat)
	if love.keyboard.isDown("lctrl", "rctrl") then
		if k == "q" then
			love.event.quit()
		elseif k == "r" then
			love.event.quit("restart")
		end
	end

	if k == "escape" then
		love.event.quit()
	end

	if not isrepeat then
		game_state:_call("keypressed", k)
	end
end

function love.keyreleased(k)
	game_state:_call("keyreleased", k)
end
