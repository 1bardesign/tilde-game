local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates");
local snake = require("ohno_a_snake");
local sounds = require("sounds");

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

	self.player_pos = vec2(10, 5)

	--temporary inline player gameobject
	table.insert(self.objects, {
		pos = self.player_pos,
		template = template.player,
		grid = self.grid, --todo: refactor, we only need this for template parsing
		move = vec2(),
		update = function(self)
			if love.keyboard.isDown("up", "w") then self.move:sset(0, -1) end
			if love.keyboard.isDown("down", "s") then self.move:sset(0, 1) end
			if love.keyboard.isDown("left", "a") then self.move:sset(-1, 0) end
			if love.keyboard.isDown("right", "d") then self.move:sset(1, 0) end
		end,
		tick = function(self)
			if self.move.x ~= 0 or self.move.y ~= 0 then
				sounds.move:setVolume(0.2)
				sounds.move:play()
				self.pos:vaddi(self.move)
				self.move:sset(0)
			end
		end,
		draw = function(self, display)
			local x, y = self.pos:vmul(self.grid.cell_size):unpack()
			self.grid:parse_template(self.template, function(ox, oy, z, glyph, colour)
				display:add(x + ox, y + oy, z, glyph, colour)
			end)
		end,
	})

	table.insert(self.objects, snake( self, 12, 5, self.grid ))
	
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
	love.graphics.translate(
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)
	love.graphics.scale(2)
	love.graphics.translate(
		self.player_pos:vmul(grid.cell_size):smuli(8):smuli(-1):roundi():unpack()
	)
	love.graphics.clear(colour.unpack_argb(self.background_colour))
	self.grid:draw(self.display)
	for _, v in ipairs(self.objects) do
		v:draw(self.display)
	end
	self.display:draw()
end

function state:keypressed(k)
	--handle keypresses
end

return state
