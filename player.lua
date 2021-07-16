--[[
	the majestic player
]]

local sounds = require("sounds");

local player = class({
	extends = require("gameobject"),
})

function player:new(game_state, pos)
	self:super(game_state)
	self.pos = pos
	self.camera_pos = pos -- hax
	self.tile_pos_prev = pos:copy()
	self.tile_pos = pos:copy()
	self.tile_lerp = 0
	self.is_lerping = false
	self.jump_dir = vec2( 0, 1 )
	self.move_queue = {}
	self.template = require("templates").player
end

function player:update(dt)
	if self.is_lerping then
		-- TODO: uncouple camera pos from player pos

		self.tile_lerp = math.min( 1, self.tile_lerp + dt * 10 )
		local dt = self.tile_lerp
		self.camera_pos = vec2.lerp( self.tile_pos_prev, self.tile_pos, dt )
		self.pos = vec2.lerp( self.tile_pos_prev, self.tile_pos, dt )
		local jump_height = ( 1 - (2*dt-1)*(2*dt-1) ) * 0.2;
		self.pos:vsubi( self.jump_dir:smul( jump_height, jump_height ) )
		
		if self.tile_lerp >= 1 then
			self.is_lerping = false
		end
	end
end

function player:tick()
	if #self.move_queue > 0 then
		local move = table.shift(self.move_queue)
		local target_pos = self.tile_pos:vadd(move)
		if not self.grid:solid_at(target_pos:unpack()) then
			self.tile_pos_prev = self.tile_pos:copy()
			self.tile_pos:vset(target_pos)

			if move.x == 0 then
				self.jump_dir = vec2( 0.35, 0.6 )
			else
				self.jump_dir = vec2( 0, 1 )
			end
	
			self.tile_lerp = 0
			self.is_lerping = true
		end
		sounds.move:setVolume(0.2)
		sounds.move:play()
		--todo: blocked sound
	end
end

function player:keypressed(k)
	local move = nil
	if k == "up" or k == "w" then move = vec2(0, -1) end
	if k == "down" or k == "s" then move = vec2(0, 1) end
	if k == "left" or k == "a" then move = vec2(-1, 0) end
	if k == "right" or k == "d" then move = vec2(1, 0) end
	if move then
		table.insert(self.move_queue, move)
	end
end

function player:draw(display)
	self:draw_template_at(display, self.pos:sadd(0, 0.1), self.template)
end

return player
