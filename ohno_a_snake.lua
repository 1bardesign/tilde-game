-- A snake
local palette = require("palette.pigment")
local template = require("templates");

local snake = class()

local type = { 
	head = 1,
	body = 2,
	tail = 3,
}

local part = function( ox, oy, dir, type )
	return { prev_pos = vec2( ox, oy ), pos = vec2( ox, oy ), dir = dir, type = type };
end

local can_enter_cell = function( parts, grid, x, y )
	local in_bounds = x >= 1 and x <= grid.size.x and y >= 1 and y <= grid.size.y;
	if not in_bounds then 
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
	self.game_state = game_state;
	self.dir = vec2( 0, -1 );
	self.length = 6;
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
	local grid = self.game_state.grid
	for i, p in ipairs( self.parts ) do
		local pos = p.pos:vmul(grid.cell_size)
		grid:parse_template(get_template( p.type, p.dir ), function(ox, oy, z, glyph, colour)
			display:add(pos.x + ox, pos.y + oy, z, glyph, colour)
		end)
	end
end

function snake:tick()
	-- TODO: Make a choice, choose new dir
	
	-- direction choices
	local directions = { self.dir, self.dir, self.dir, self.dir, self.dir, self.dir, self.dir, self.dir, vec2( 0, 1 ), vec2( 0, -1 ), vec2( 1, 0 ), vec2( -1, 0 ) };
	while #directions > 0 do
		local direction = tablex.take_random( directions );
		local new_head_pos = self.parts[1].pos:vadd( direction );
		if can_enter_cell( self.parts, self.game_state.grid, new_head_pos.x, new_head_pos.y ) then
			self.dir = direction;

			for i=#self.parts,1,-1 do
				-- Move to new position
				local p = self.parts[i];
				local new_pos = i == 1 and new_head_pos or self.parts[i - 1].pos;
				p.prev_pos = p.pos;
				p.pos = new_pos;
			end

			break;
		end
	end
end

return snake
