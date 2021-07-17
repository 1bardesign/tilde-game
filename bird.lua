local template = require("templates_creatures")

local bird = class({
	extends = require("gameobject")
})

function bird:new(game_state, ox, oy)
	self:super(game_state)
	self.choice_delay = 0
	self.origin = vec2( ox, oy )
	self.angle = love.math.random() * 2 * math.pi
	self.radius = 5 + love.math.random() * 10
	self.animate_timer = 0
	self.pos = vec2( 0, 0 )
	self.speed = 0.05 + love.math.random() * 0.05
	self:update(0)
end

function bird:update(dt)
	self.angle = self.angle + dt * self.speed
	self.animate_timer = self.animate_timer + dt
	-- Update pos - fly in a circle

	local x = self.origin.x + self.radius * math.cos( self.angle )
	local y = self.origin.y + self.radius * math.sin( self.angle )
	self.pos:sset( x, y )
end

function bird:draw(display)
	local frame = math.floor( self.animate_timer * 5 ) % 2
	-- self.pos = start_pos:to_world_coords( self.grid.cell_size )
	local z_offset = 5;
	self:draw_template_at(display, self.pos, frame == 0 and template.bird.frame_1 or template.bird.frame_2, z_offset )
end

function bird:tick()
end

return bird
