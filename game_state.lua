local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates");

local state = class()

--setup instance
function state:new()
	self.background_colour = palette.dark
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.grid = grid(20, 10)

	for y = 1, self.grid.size.y do
		for x = 1, self.grid.size.x do
			local t = template.grass
			local r = love.math.random();
			if r < 0.1 then
				t = template.flowers
			elseif r < 0.2 then
				t = template.tree
			elseif r < 0.22 then
				t = template.rocks
			end
			self.grid:set_template(
				x, y,
				table.pick_random(t)
			)
		end
	end

	self.player_pos = vec2(10, 5)
	self.grid:clear(self.player_pos:unpack())
	self.grid:set_template(
		self.player_pos.x, self.player_pos.y,
		template.player
	)
end

function state:update(dt)
	--update each tick
end

function state:draw()
	love.graphics.translate(
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)
	love.graphics.scale(2)
	love.graphics.translate(
		self.player_pos:vmul(grid.cell_size):smuli(-1):roundi():unpack()
	)
	love.graphics.clear(colour.unpack_argb(self.background_colour))
	self.grid:draw()
end

function state:keypressed(k)
	--handle keypresses
end

return state
