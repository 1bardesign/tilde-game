-- A snake
local palette = require("palette.pigment")
local template = require("templates")
local sounds = require("sounds")

local snake = class({
	extends = require("gameobject")
})

local type = { 
	head = 1,
	body = 2,
	tail = 3,
}

local part = function( ox, oy, dir, type )
	return { prev_pos = vec2( ox, oy ), pos = vec2( ox, oy ), dir = dir, type = type };
end

local can_enter_cell = function( parts, grid, x, y )
	if grid:solid_at(x, y) then
		return false;
	else
		for i=2,#parts do
			if parts[i].pos.x == x and parts[i].pos.y == y then
				return false;
			end
		end
	end
	return true;
end

local get_template = function( part_type, dir )
	if part_type == type.head then
		return template.snake.head
	elseif part_type == type.body then
		if dir.y == -1 then
			return template.snake.body.n
		elseif dir.y == 1 then
			return template.snake.body.s
		elseif dir.x == 1 then
			return template.snake.body.e
		elseif dir.x == -1 then
			return template.snake.body.w
		end
	elseif part_type == type.tail then
		if dir.y == -1 then
			return template.snake.tail.n
		elseif dir.y == 1 then
			return template.snake.tail.s
		elseif dir.x == 1 then
			return template.snake.tail.e
		elseif dir.x == -1 then
			return template.snake.tail.w
		end
	end
end

function snake:new(game_state, ox, oy)
	self:super(game_state)
	self.dir = vec2( 0, -1 );
	self.length = 6;
	self.choice_delay = 0;
	self.parts = {
		part( ox, oy, self.dir, type.head ),
		part( ox, oy + 1, self.dir, type.body ),
		part( ox, oy + 2, self.dir, type.body ),
		part( ox, oy + 3, self.dir, type.body ),
		part( ox, oy + 4, self.dir, type.body ),
		part( ox, oy + 5, self.dir, type.tail )
	}
end

function snake:update(dt)
	-- Wiggle / animate etc
end

function snake:draw(display)
	local grid = self.grid
	for i, p in ipairs( self.parts ) do
		self:draw_template_at(display, p.pos, get_template( p.type, p.dir ))
	end
end

function snake:tick()
	-- TODO: Make a choice, choose new dir
	self.choice_delay = self.choice_delay - 1;
	if self.choice_delay > 0 then
		return;
	end

	local choice = love.math.random();
	local choose_move = choice > 0.04;

	if choose_move then
		self.choice_delay = 0;

		-- direction choices
		local directions = table.shuffle({
			--bias current dir
			self.dir, self.dir, self.dir, self.dir,
			--cardinal
			vec2(0, 1), vec2(0, -1), vec2(1, 0), vec2(-1, 0)
		})
		local player_direction, player_distance = self.game_state.player.pos:vsub(self.parts[1].pos):normalisei_both()
		local player_near = player_distance < 20
		local chosen_dir = functional.find_best(directions, function(d)
			local new_head_pos = self.parts[1].pos:vadd(d)
			if not can_enter_cell(self.parts, self.game_state.grid, new_head_pos.x, new_head_pos.y) then
				return nil
			end
			--not near player, just wander
			if not player_near then
				return love.math.random()
			end
			--near player, take direction into account
			return d:dot(player_direction) + love.math.random()
		end)
		if chosen_dir then
			sounds.serpent_move:play()

			self.dir = chosen_dir

			for i = #self.parts, 1, -1 do
				-- Move to new position
				local p = self.parts[i];
				local new_pos = i == 1 and p.pos:vadd(self.dir) or self.parts[i - 1].pos;
				p.prev_pos = p.pos;
				p.pos = new_pos;
			end

			for i = 1, #self.parts do
				local p = self.parts[i];
				p.dir = i == 1 and self.dir or self.parts[i-1].pos:vsub(p.pos);
			end
		end
		self.choice_delay = 3;
	else
		-- Growl 
		self.choice_delay = 5;
		sounds.serpent_growl:play()
	end
end

return snake
