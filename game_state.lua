local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates");
local snake = require("ohno_a_snake");

local state = class()

--setup instance
function state:new()
	self.background_colour = palette.dark
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
	self.grid = grid(20, 10)
	self.objects = {}
	
	local width = 20
	local height = 10

	self.grid = grid(width, height)

	-- TODO: Move world creation to separate file
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

	--temporary inline player gameobject
	self.player = require("player")(self, vec2(10, 5))
	table.insert(self.objects, self.player)

	self.snake = snake( self, 12, 5, self.grid )
	table.insert(self.objects, self.snake)
	
	self.time_since_last_tick = 0
end

function state:tick()
	for _, v in ipairs(self.objects) do
		v:tick()
	end
end

function state:update(dt)
	-- tick in soft-realtime
	self.time_since_last_tick = self.time_since_last_tick + dt
	if self.time_since_last_tick > 0.33 then
		self.time_since_last_tick = 0
		self:tick()
	end

	--update everything
	for _, v in ipairs(self.objects) do
		v:update(dt)
	end
end

function state:draw()
	--set up camera
	love.graphics.translate(
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)
	love.graphics.scale(2)
	love.graphics.translate(
		self.player.pos:vmul(grid.cell_size):smuli(8):smuli(-1):unpack()
	)
	--draw world
	love.graphics.clear(colour.unpack_argb(self.background_colour))
	self.grid:draw(self.display)
	--draw objects
	for _, v in ipairs(self.objects) do
		v:draw(self.display)
	end
	--display
	self.display:draw()
end

function state:keypressed(k)
	--hand off to objects
	for _, v in ipairs(self.objects) do
		v:keypressed(k)
	end
end

return state
