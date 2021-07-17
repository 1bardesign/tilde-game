--[[
	the majestic player
]]

local sounds = require("sounds");
local template = require("templates");

local player = class({
	extends = require("gameobject"),
})

function player:new(game_state, pos)
	self:super(game_state)
	self.pos = pos
	self.camera_pos = pos:copy()
	self.tile_pos_prev = pos:copy()
	self.tile_pos = pos:copy()
	self.tile_pos_wander = pos:copy()
	self.tile_lerp = 0
	self.is_lerping = false
	self.jump_dir = vec2( 0, 1 )
	self.move_queue = {}
	self.current_command = nil
	self.active_commands = {}
	self.template = require("templates").player
	self.ticker = 0
	self.stepper = 0
	self.step_sound_timer = 0
end

function player:update(dt)
	if self.is_lerping then
		local speed = 5 -- 10
		self.tile_lerp = math.min( 1, self.tile_lerp + dt * speed )
		local f = self.tile_lerp
		self.pos = vec2.lerp(self.tile_pos_prev, self.tile_pos_wander, f)

		local dj = (f % 0.5) / 0.5
		local jump_height = ( 1 - (2*dj-1)*(2*dj-1) ) * 0.2;
		self.pos:vsubi( self.jump_dir:smul( jump_height, jump_height ) )
		
		if self.tile_lerp >= 1 then
			self.is_lerping = false
		end

		self.step_sound_timer = self.step_sound_timer - dt
		if self.step_sound_timer <= 0 then
			self.step_sound_timer = 0.1

			local cell = self.grid:cell( self.tile_pos.x, self.tile_pos.y );
			local in_water = cell.template == template.water[1]; -- gross

			local sound = in_water and sounds.sound.move_water or sounds.sound.move;

			self.stepper = ( self.stepper + 1 ) % 2
			if self.stepper == 0 then
				sound:setPitch( 1.0 + 0.5 * love.math.random() )
			else
				sound:setPitch( 0.5 + 0.5 * love.math.random() )
			end
			love.audio.stop( sound )
			sounds.play( sound, 0.5 )
			--todo: blocked sound
		end
	end
	self.camera_pos:lerpi(self.pos, dt * 5)
end

function player:tick()
	self.ticker = self.ticker - 1
	if self.ticker > 0 then
		return
	end
	self.ticker = 2

	if self.current_command then
		table.push( self.move_queue, self.current_command )
	end

	if #self.move_queue > 0 then
		local move = table.shift(self.move_queue)
		local target_pos = self.tile_pos:vadd(move)
		if not self.grid:solid_at(target_pos:unpack()) then
			self.tile_pos:vset(target_pos)
			self.tile_pos_prev = self.tile_pos_wander:copy()
			local wander_rad = 0 --  0.5 / 3
			self.tile_pos_wander:sset(wander_rad, 0)
				:rotatei(love.math.random() * math.tau)
				:vaddi(self.tile_pos)

			if move.x == 0 then
				self.jump_dir = vec2( 0.35, 0.6 )
			else
				self.jump_dir = vec2( 0, 1 )
			end
	
			if self.is_lerping then
				-- snap
				self.pos = self.tile_pos_prev:copy()
			end
			self.tile_lerp = 0
			self.is_lerping = true

			self.game_state:update_player_region( target_pos )
		end
		
		
		self.step_sound_timer = 0
		
	end
end

local get_command = function( k )
	local move = nil
	if k == "up" or k == "w" then move = vec2(0, -1) end
	if k == "down" or k == "s" then move = vec2(0, 1) end
	if k == "left" or k == "a" then move = vec2(-1, 0) end
	if k == "right" or k == "d" then move = vec2(1, 0) end
	return move
end

function player:keypressed(k)
	self.current_command = get_command( k )
	if self.current_command then
		self.ticker = 0
	end
	self.active_commands[ k ] = true
end

function player:keyreleased(k)
	self.current_command = nil
	self.active_commands[ k ] = nil
	for k, v in pairs( self.active_commands ) do
		if v then
			self.current_command = get_command( k )
			break
		end
	end
end

function player:draw(display)
	self:draw_template_at(display, self.pos, self.template)
end

return player
