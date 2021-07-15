local state = class()

function state:new()
	--setup instance
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
end

function state:update(dt)
	--update each tick
end

function state:draw()
	love.graphics.print("hi ben!", 10, 10)
end

function state:keypressed(k)
	--handle keypresses
end

return state
