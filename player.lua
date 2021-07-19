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
			local in_water = cell.type == "water"

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


local function find_target_pos( grid, pos, dir )
	local target_pos = pos:vadd( dir )
	if not grid:solid_at(target_pos:unpack()) then
		return target_pos
	end

	if dir.x ~= 0 and dir.y ~= 0 then
		-- When moving diagonally try to push perpendicular to obstacles
		local test_pos1 = pos:vadd( vec2( 0, dir.y ) )
		local test_pos2 = pos:vadd( vec2( dir.x, 0 ) )

		if not grid:solid_at(test_pos1:unpack()) then
			return test_pos1
		end

		if not grid:solid_at(test_pos2:unpack()) then
			return test_pos2
		end
	end

	if dir.x == 0 or dir.y == 0 then
		-- When moving orthogonally try to push diagonally around obstacles
		local test_pos1 = dir.y == 0 and pos:vadd( dir ):vadd( vec2( 0, -1 ) ) or pos:vadd( dir ):vadd( vec2( -1, 0 ) )
		local test_pos2 = dir.y == 0 and pos:vadd( dir ):vadd( vec2( 0, 1 ) ) or pos:vadd( dir ):vadd( vec2( 1, 0 ) )

		if not grid:solid_at(test_pos1:unpack()) then
			return test_pos1
		end

		if not grid:solid_at(test_pos2:unpack()) then
			return test_pos2
		end
	end
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
		local target_pos = find_target_pos( self.grid, self.tile_pos, move )
		if target_pos then
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

local combine_commands = function( commands )
	local combined_move = vec2( 0, 0 )
	for k, v in pairs( commands ) do
		if v then
			local move = vec2( 0, 0 )
			if k == "up" or k == "w" then move = vec2(0, -1) end
			if k == "down" or k == "s" then move = vec2(0, 1) end
			if k == "left" or k == "a" then move = vec2(-1, 0) end
			if k == "right" or k == "d" then move = vec2(1, 0) end
			combined_move:vaddi( move )
		end
	end
	if combined_move.x ~= 0 or combined_move.y ~= 0 then
		combined_move.x = math.clamp( combined_move.x, -1, 1 )
		combined_move.y = math.clamp( combined_move.y, -1, 1 )
		return combined_move
	end
end

function player:keypressed(k)
	local has_existing_command = table.key_of( self.active_commands, true ) ~= nil
	self.active_commands[ k ] = true
	self.current_command = combine_commands( self.active_commands )
	if self.current_command and not has_existing_command then
		self.ticker = 0
	end
end

function player:keyreleased(k)
	self.current_command = nil
	self.active_commands[ k ] = nil
	self.current_command = combine_commands( self.active_commands )
end

function player:draw(display)
	self:draw_template_at(display, self.pos, self.template)
end

return player
