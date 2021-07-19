local grid = require("grid")

local palette = require("palette.pigment")
local sounds = require("sounds")

local state = class()

--setup instance
function state:new()
	ZOOM_LEVEL = math.ceil(love.graphics.getHeight() / 1080 * 3)

	self.background_colour = palette.dark

	self.ambient_loop = love.audio.newSource( "wav/ambience.wav", "static" )
	self.ambient_loop:setLooping( true )
	self.ambient_loop:setVolume( 0.25 )
	love.audio.play(self.ambient_loop)
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
end

function state:exit()
	self.ambient_loop:stop()
end

function state:update(dt)
	if self.done then
		sounds.play(sounds.sound.move, 1)
		return "game"
	end
end

function state:draw()
	--set up camera
	love.graphics.push("all")
	love.graphics.translate(
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)
	love.graphics.scale(ZOOM_LEVEL)
	--draw world
	love.graphics.clear(colour.unpack_argb(self.background_colour))
	
	-- draw title screen
	local flash_period = 1
	local flash = math.wrap(love.timer.getTime(), 0, flash_period) < flash_period / 2 and palette.white or palette.grey
	for _, v in ipairs({
		{-4, palette.green, "~", },
		{-2, palette.fawn, "(pronounced \"tilde\")", },
		{2, palette.fawn, "a game by ben and max", },
		{4, palette.fawn, "july 2021" },
		{8, flash, "press any key to start" },
	}) do
		local oy, col, s = unpack(v)
		for i, char in ipairs(s:split()) do
			self.display:add(i - #s / 2 - 1, oy, 0, char, col)
		end
	end

	--display
	self.display:draw()

	--
	love.graphics.pop()
end

function state:keypressed(k)
	self.done = true
end

function state:keyreleased(k)
	
end

return state
