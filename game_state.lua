local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates")

local state = class()

--setup instance
function state:new()
	self.background_colour = palette.dark
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
	self.objects = {}
	
	require("generate_world")(self) -- populates the structures below
	assert( self.grid )
	assert( self.player_spawns )
	assert( self.snake_spawns )

	local player_spawn = tablex.pick_random( self.player_spawns );
	self.player = require("player")(self, player_spawn )
	table.insert(self.objects, self.player)

	local snake_spawn = tablex.pick_random( self.snake_spawns );
	self.snake = require("ohno_a_snake")( self, snake_spawn.x, snake_spawn.y, self.grid )
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
	if self.time_since_last_tick > 0.1 then
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
		self.player.camera_pos:vmul(grid.cell_size):smuli(8):smuli(-1):unpack()
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
