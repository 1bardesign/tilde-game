local grid = require("src.grid")

local palette = require("src.palette.pigment")
local sounds = require("src.sounds")

local state = class()

--setup instance
function state:new()
	self.background_colour = palette.dark
	self.already_played = nil

	self.ambient_loop = love.audio.newSource( "assets/wav/ambience.wav", "static" )
	self.ambient_loop:setLooping( true )
	self.ambient_loop:setVolume( 0.25 )
	love.audio.play(self.ambient_loop)
end

function state:enter()
	self.display = require("src.ascii3d")()

	--
	SCREEN_OVERLAY:flash(palette.dark, 1)
	self.done = false
	self.next = "game"
end

function state:exit()
	self.ambient_loop:stop()
end

function state:update(dt)
	if self.done then
		if SCREEN_OVERLAY:done() then
			self.already_played = true
			return self.next
		end
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
	for _, v in ipairs(table.append_inplace({
			{-6, palette.green, "~", },
			{-4, palette.fawn, self.already_played and "you are safely home" or "the path home", },
			{0, palette.fawn, "max cahill", },
			{2, palette.fawn, "ben porter", },
		},
		{
			{12, flash, self.already_played and "press any key to play again" or "press any key to play" },
			{14, palette.fawn, "press escape to quit" },
		}
	)) do
		local oy, col, s = unpack(v)
		for i = 1, #s do
			self.display:add(i - #s / 2 - 1, oy, 0, s:byte(i), col)
		end
	end

	--display
	self.display:draw()

	--
	love.graphics.pop()
end

function state:keypressed(k)
	if self.done then return end

	if k == "escape" then
		self.next = "quit"
	end

	self.done = true
	SCREEN_OVERLAY:fade(palette.dark, 1)
	sounds.play(sounds.sound.move, 1)
end

function state:keyreleased(k)
	
end

return state
