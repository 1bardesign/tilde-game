local palette = require("palette.pigment")
local template = require("templates_creatures")
local sounds = require("sounds")
local world_pos = require("world_pos")

local frog = class({
	extends = require("gameobject")
})

local can_enter_cell = function( grid, x, y )
	return not grid:solid_at(x, y);
end

function frog:new(game_state, ox, oy)
	self:super(game_state)
	self.choice_delay = 0
	local start_pos = world_pos( ox, oy, 2, 3 )
	self.prev_pos = start_pos:copy()
	self.next_pos = start_pos:copy()
	self.pos_wc = start_pos:to_world_coords( self.grid.cell_size )
	self.pos_lerp = 0
	self.is_lerping = false
	self.jump_dir = vec2( 0, 1 )
	self.agitate_timer = 0
	self.animate_timer = 0
	self.ticker = 0
end

function frog:update(dt)
	-- Wiggle / animate etc
	if self.is_lerping then
		self.pos_lerp = math.min( 1, self.pos_lerp + dt * 7 )
		
		local prev_wc = self.prev_pos:to_world_coords( self.grid.cell_size )
		local next_wc = self.next_pos:to_world_coords( self.grid.cell_size )
		local f = self.pos_lerp
		self.pos_wc = vec2.lerp(prev_wc, next_wc, f)
		
		local jump_height = ( 1 - (2*f-1)*(2*f-1) ) * 1;
		self.pos_wc:vsubi( self.jump_dir:smul( jump_height, jump_height ) )
		
		if self.pos_lerp >= 1 then
			self.is_lerping = false
		end
	end

	if self.animate_timer > 0 then
		self.animate_timer = self.animate_timer - dt
	end
end

function frog:draw(display)

	if self.animate_timer > 0 then
		display:add( self.pos_wc.x, self.pos_wc.y - 1, 1, template.frog.glyph_anim_head, palette.green )
		display:add( self.pos_wc.x, self.pos_wc.y, 1, template.frog.glyph_anim_legs, palette.green )
	else
		display:add( self.pos_wc.x, self.pos_wc.y, 1, template.frog.glyph_sit, palette.green )
	end
end

function frog:tick()
	if self.ticker > 0 then
		self.ticker = self.ticker - 1
		return
	end

	self.ticker = 2

	self.choice_delay = self.choice_delay - 1;
	if self.choice_delay > 0 then
		return
	end

	local agitated = self.agitate_timer > 0
	if self.agitate_timer > 0 then
		self.agitate_timer = self.agitate_timer - 1
	end

	local choice = love.math.random();
	local choose_move = agitated or ( choice < 0.4 );

	local player_direction, player_distance = self.game_state.player.pos:vsub(self.next_pos.p):normalisei_both()
	local player_near = player_distance < 2

	if choose_move or player_near then
		self.choice_delay = 0;

		local chosen_dir = nil
		if player_near then
			-- Flee
			chosen_dir = player_direction:inverse()
			agitated = true
			self.agitate_timer = 5
		else 
			local directions = { vec2(0, 1), vec2(0, -1), vec2(1, 0), vec2(-1, 0) }
			chosen_dir = table.pick_random( directions )
		end
		if chosen_dir then
			local new_pos = self.next_pos:add( nil, chosen_dir );
			if can_enter_cell( self.game_state.grid, new_pos.p.x, new_pos.p.y) then
				-- sounds.serpent_move:play()
				self.dir = chosen_dir
				self.prev_pos = self.next_pos
				self.next_pos = new_pos
				if self.dir.x == 0 then
					self.jump_dir = vec2( 0.35, 0.6 )
				else
					self.jump_dir = vec2( 0, 1 )
				end
				self.pos_lerp = 0
				self.is_lerping = true
				self.animate_timer = 0.2
			end
		end

		if not agitated then
			self.choice_delay = math.floor( 2 + 2 * love.math.random() )
		end
	else
		-- Emote 
		self.choice_delay = 5;
		-- sounds.serpent_growl:play()
	end
end

return frog
